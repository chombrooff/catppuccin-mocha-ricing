source "$SOURCE_DIR/core/model/paths.model.sh"
source "$SOURCE_DIR/core/service/backup.service.sh"
source "$SOURCE_DIR/core/ui/messages.ui.sh"

uninstall_remove_configs() {
    log "Removing configuration files ..."

    link_remove_entry_points

    for module in "${MODULES[@]}"; do
        local dest="${TARGET_MAP[$module]}"

        if [ ! -d "$dest" ]; then
            warn "No config found for: $module"
            continue
        fi

        if [ "$module" = "gtk" ]; then
            rm -f "$dest/settings.ini" 2>/dev/null || true
            rmdir "$dest" 2>/dev/null || true
        else
            rm -rf "$dest"
        fi

        ok "Removed: $module"
    done

    rm -f "$HOME/.icons/default/index.theme" 2>/dev/null || true
    ok "Removed: cursor theme"
}

uninstall_dry_run() {
    echo ""
    log "Dry run — files that will be removed:"

    for module in "${MODULES[@]}"; do
        local dest="${TARGET_MAP[$module]}"

        if [ "$module" = "gtk" ]; then
            if [ -f "$dest/settings.ini" ]; then
                local size
                size=$(du -sh "$dest/settings.ini" 2>/dev/null | cut -f1)
                echo "  - $dest/settings.ini  ($size)"
            else
                echo "  - $dest/settings.ini  (not found)"
            fi
        elif [ -d "$dest" ]; then
            local size
            size=$(du -sh "$dest" 2>/dev/null | cut -f1)
            echo "  - $dest  ($size)"
        else
            echo "  - $dest  (not found)"
        fi
    done

    if [ -d "$CONFIG_DIR/hypr/hyprpaper.d" ]; then
        local ws
        ws=$(du -sh "$CONFIG_DIR/hypr/hyprpaper.d" 2>/dev/null | cut -f1)
        echo "  - $CONFIG_DIR/hypr/hyprpaper.d  ($ws)"
    fi
    echo ""
}

uninstall_run() {
    print_header

    local mode="${1:-interactive}"

    if [ "$mode" = "dry-run" ]; then
        uninstall_dry_run
        return 0
    fi

    if has_backup; then
        warn "Backup available at $BACKUP_DIR"
        log "You can restore later with: bash restore.sh"
    fi

    if [ "$mode" != "force" ]; then
        if ! prompt_confirm "Remove ALL Catppuccin Mocha configs?"; then
            log "Uninstall cancelled"
            return 1
        fi
    fi

    uninstall_remove_configs

    if prompt_confirm "Also uninstall packages (hyprland, waybar, rofi, kitty, swaync, wlogout, hyprpaper)?"; then
        log "Removing packages ..."
        sudo pacman -Rns hyprland waybar rofi kitty swaync wlogout hyprpaper 2>/dev/null || true
        ok "Packages removed"
    fi

    killall waybar 2>/dev/null || true
    killall swaync 2>/dev/null || true

    echo ""
    ok "Uninstall complete"
    log "To restore your backup: bash restore.sh"
}
