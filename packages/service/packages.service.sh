source "$SOURCE_DIR/core/ui/messages.ui.sh"
source "$SOURCE_DIR/packages/model/packages.model.sh"

package_install() {
    log "Checking packages ..."
    local all_missing=()

    for group in "${PACKAGE_GROUPS[@]}"; do
        for pkg in $group; do
            if ! pacman -Q "$pkg" &>/dev/null; then
                all_missing+=("$pkg")
            fi
        done
    done

    if [ ${#all_missing[@]} -eq 0 ]; then
        ok "All packages installed"
        return 0
    fi

    warn "Missing ${#all_missing[@]} packages"
    if prompt_confirm "Install missing packages?"; then
        sudo pacman -S --needed "${all_missing[@]}"
        ok "Packages installed"
    else
        warn "Skipping installation: sudo pacman -S ${all_missing[*]}"
    fi
}

package_list_missing() {
    local missing=()

    for group in "${PACKAGE_GROUPS[@]}"; do
        for pkg in $group; do
            if ! pacman -Q "$pkg" &>/dev/null; then
                missing+=("$pkg")
            fi
        done
    done

    echo "${missing[@]}"
}

package_is_installed() {
    local pkg="$1"
    pacman -Q "$pkg" &>/dev/null
}
