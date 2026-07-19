source "$SOURCE_DIR/core/model/paths.model.sh"
source "$SOURCE_DIR/core/service/backup.service.sh"
source "$SOURCE_DIR/core/ui/messages.ui.sh"
source "$SOURCE_DIR/core/utility/validation.util.sh"
source "$SOURCE_DIR/installer/service/dependency.service.sh"
source "$SOURCE_DIR/installer/service/link.service.sh"
source "$SOURCE_DIR/packages/service/packages.service.sh"
source "$SOURCE_DIR/gtk/controller/gtk.controller.sh"

install_run() {
    print_header

    if [ -n "$PREFIX" ]; then
        log "Custom prefix: $PREFIX"
    fi
    log "Install mode: ${LINK_MODE:-copy}"

    if ! prompt_confirm "Install Catppuccin Mocha ricing on this system?"; then
        log "Installation cancelled"
        exit 0
    fi

    package_install

    backup_create

    local results=()

    for module in "${MODULES[@]}"; do
        local src="$SOURCE_DIR/$module"
        local dest="${TARGET_MAP[$module]}"

        if [ ! -d "$src" ]; then
            warn "Source directory $src not found, skipping $module"
            continue
        fi

        mkdir -p "$dest"
        link_install "$src" "$dest"
        link_entry_points "$module"
        results+=("${GREEN}✔${NC} $module → $dest")
    done

    log "Installing default wallpaper ..."
    mkdir -p "$CONFIG_DIR/hypr/hyprpaper.d"
    if [ -f "$SOURCE_DIR/backgrounds/default.png" ]; then
        cp "$SOURCE_DIR/backgrounds/default.png" "$CONFIG_DIR/hypr/hyprpaper.d/default.png"
        ok "Wallpaper installed"
    fi

    log "Linking shared palette ..."
    local shared_palette="$SOURCE_DIR/core/model/catppuccin-mocha.css"
    for mod in waybar swaync wlogout; do
        local target="${TARGET_MAP[$mod]}/model/colors.model.css"
        if [ -f "$target" ]; then
            rm -f "$target"
        fi
        ln -sf "$shared_palette" "$target"
        ok "Linked: $mod → core palette"
    done

    print_summary "${results[@]}"

    log "Applying GTK settings ..."
    gtk_apply_all

    log "Restarting services ..."
    killall waybar 2>/dev/null || true
    killall swaync 2>/dev/null || true
    waybar &>/dev/null &
    swaync &>/dev/null &

    ok "Installation complete"
    warn "Restart Hyprland (SUPER+M or logout) for full effect"
    log "Restore with: bash restore.sh"
}

install_run
