source "$SOURCE_DIR/core/model/paths.model.sh"
source "$SOURCE_DIR/core/service/backup.service.sh"
source "$SOURCE_DIR/core/ui/messages.ui.sh"

restore_interactive() {
    print_header

    local backups=("$BACKUP_DIR"/*/)
    if [ ! -d "$BACKUP_DIR" ] || [ ${#backups[@]} -eq 0 ]; then
        err "No backups found at $BACKUP_DIR"
        return 1
    fi

    log "Available backups:"
    local i=1
    for b in "${backups[@]}"; do
        local name
        name=$(basename "$b")
        local size
        size=$(du -sh "$b" 2>/dev/null | cut -f1)
        echo "  $i) $name  ($size)"
        i=$((i + 1))
    done

    echo ""
    read -rp "Enter number to restore (or q to quit): " choice

    if [ "$choice" = "q" ]; then
        log "Restore cancelled"
        return 1
    fi

    local index=$((choice - 1))
    if [ "$index" -lt 0 ] || [ "$index" -ge ${#backups[@]} ]; then
        err "Invalid selection"
        return 1
    fi

    local selected="${backups[$index]}"
    local ts
    ts=$(basename "$selected")

    if ! prompt_confirm "Restore from $ts? This will overwrite current configs"; then
        log "Restore cancelled"
        return 1
    fi

    backup_restore "$ts" || {
        err "Restore failed"
        return 1
    }

    killall waybar 2>/dev/null || true
    killall swaync 2>/dev/null || true
    waybar &>/dev/null &
    swaync &>/dev/null &

    ok "Restore complete"
    warn "Restart Hyprland for full effect"
}

if [ -n "${TIMESTAMP:-}" ]; then
    backup_restore "$TIMESTAMP"
else
    restore_interactive
fi
