source "$SOURCE_DIR/core/ui/messages.ui.sh"

gtk_apply_settings() {
    local dest="$HOME/.config/gtk-3.0"
    mkdir -p "$dest"
    cp "$SOURCE_DIR/gtk/model/theme.model.ini" "$dest/settings.ini"
    ok "GTK settings applied"
}

gtk_apply_cursor_theme() {
    mkdir -p "$HOME/.icons/default"
    cat > "$HOME/.icons/default/index.theme" << 'EOF'
[Icon Theme]
Inherits=Bibata-Modern-Classic
EOF
    ok "Cursor theme set"
}

gtk_apply_icon_theme() {
    if command -v gsettings &>/dev/null; then
        gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark" 2>/dev/null || true
        gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Classic" 2>/dev/null || true
    fi
    ok "Icon theme set"
}

gtk_apply_all() {
    gtk_apply_settings
    gtk_apply_cursor_theme
    gtk_apply_icon_theme
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then
    gtk_apply_all
fi