dependency_check() {
    log "Checking dependencies ..."
    local missing=()

    for pkg in "${REQUIRED_PACKAGES[@]}"; do
        if ! pacman -Q "$pkg" &>/dev/null; then
            missing+=("$pkg")
        fi
    done

    if [ ${#missing[@]} -gt 0 ]; then
        warn "Missing packages: ${missing[*]}"
        if prompt_confirm "Install missing packages?"; then
            sudo pacman -S --needed "${missing[@]}"
            ok "Dependencies installed"
        else
            warn "Skipping dependency installation (manual: sudo pacman -S ${missing[*]})"
        fi
    else
        ok "All dependencies met"
    fi
}
