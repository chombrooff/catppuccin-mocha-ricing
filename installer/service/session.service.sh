source "$SOURCE_DIR/core/ui/messages.ui.sh"

SESSION_DESKTOP="/usr/share/wayland-sessions/hyprland.desktop"
BASH_PROFILE="$HOME/.bash_profile"
TTY_MARKER="# Catppuccin Mocha — auto-start Hyprland"

session_ensure_desktop_file() {
    if [ -f "$SESSION_DESKTOP" ]; then
        ok "Hyprland session file exists: $SESSION_DESKTOP"
        return 0
    fi

    log "Creating Hyprland session file for display manager ..."
    local content='[Desktop Entry]
Type=Application
Name=Hyprland
Comment=Hyprland Wayland compositor
Exec=Hyprland
'
    if echo "$content" | sudo tee "$SESSION_DESKTOP" > /dev/null; then
        ok "Session file created for SDDM/GDM"
    else
        warn "Could not create $SESSION_DESKTOP (sudo needed)"
    fi
}

session_setup_tty_autostart() {
    log "Setting up Hyprland session for $USER ..."

    if [ -f "$BASH_PROFILE" ] && grep -q "$TTY_MARKER" "$BASH_PROFILE" 2>/dev/null; then
        ok "TTY auto-start already configured"
        return 0
    fi

    if ! prompt_confirm "Add auto-start Hyprland on TTY login?"; then
        log "Skipping TTY auto-start"
        return 0
    fi

    if [ ! -f "$BASH_PROFILE" ]; then
        echo "#!/bin/bash" > "$BASH_PROFILE"
    fi

    cat >> "$BASH_PROFILE" << 'EOF'

# Catppuccin Mocha — auto-start Hyprland
if [ -z "$WAYLAND_DISPLAY" ] && [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec Hyprland
fi
EOF

    ok "TTY auto-start added to $BASH_PROFILE"
    warn "Logout or reboot to test: login on tty1 → Hyprland starts automatically"
}

session_apply_all() {
    log "Configuring system session ..."
    session_ensure_desktop_file
    session_setup_tty_autostart
    ok "Session setup complete"
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then
    session_apply_all
fi
