source "$SOURCE_DIR/core/model/paths.model.sh"

validate_prefix() {
    local prefix="$1"
    if [ -z "$prefix" ]; then
        return 0
    fi
    if [ "$prefix" = "/" ]; then
        err "Invalid prefix: '/' — would install to system root"
        return 1
    fi
    if [ ! -d "$prefix" ] && ! mkdir -p "$prefix" 2>/dev/null; then
        err "Prefix not writable: $prefix"
        return 1
    fi
    return 0
}

check_deps() {
    local missing=()

    for pkg in "${REQUIRED_PACKAGES[@]}"; do
        if ! pacman -Q "$pkg" &>/dev/null; then
            missing+=("$pkg")
        fi
    done

    if [ ${#missing[@]} -gt 0 ]; then
        err "Missing packages: ${missing[*]}"
        log "Install: sudo pacman -S ${missing[*]}"
        return 1
    fi

    return 0
}

check_path() {
    local path="$1"
    if [ -d "$path" ]; then
        return 0
    fi
    return 1
}

validate_theme() {
    local theme_dir="$1"
    local required_files=(
        "hypr/controller/hyprland.controller.conf"
        "waybar/controller/waybar.controller.jsonc"
        "rofi/controller/rofi.controller.rasi"
        "kitty/controller/kitty.controller.conf"
    )

    for file in "${required_files[@]}"; do
        if [ ! -f "$theme_dir/$file" ]; then
            err "Missing required file: $file"
            return 1
        fi
    done

    return 0
}

is_hyprland_running() {
    if pgrep -x Hyprland >/dev/null 2>&1; then
        return 0
    fi
    return 1
}
