source "$SOURCE_DIR/core/repository/filesystem.repo.sh"

backup_create() {
    local timestamp
    timestamp=$(date +%Y%m%d-%H%M%S)
    local dest="$BACKUP_DIR/$timestamp"

    log "Creating backup at $dest ..."
    mkdir -p "$dest"

    for module in "${MODULES[@]}"; do
        local src="${TARGET_MAP[$module]}"
        if [ -d "$src" ]; then
            fs_copy "$src" "$dest/${module}" || return 1
            ok "Backed up: $module"
        else
            warn "No existing config for: $module"
        fi
    done

    echo "$dest"
    return 0
}

has_backup() {
    if [ -d "$BACKUP_DIR" ] && [ "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]; then
        return 0
    fi
    return 1
}

backup_list() {
    if [ ! -d "$BACKUP_DIR" ]; then
        err "No backup directory found"
        return 1
    fi

    local backups=("$BACKUP_DIR"/*/)
    if [ ${#backups[@]} -eq 0 ]; then
        err "No backups found"
        return 1
    fi

    local i=1
    for b in "${backups[@]}"; do
        local size
        size=$(du -sh "$b" 2>/dev/null | cut -f1)
        local date_str
        date_str=$(basename "$b")
        log "  $i) $date_str  ($size)"
        i=$((i + 1))
    done
}

backup_restore() {
    local timestamp="$1"
    local src="$BACKUP_DIR/$timestamp"

    if [ ! -d "$src" ]; then
        err "Backup not found: $timestamp"
        return 1
    fi

    log "Restoring from $timestamp ..."
    for module in "${MODULES[@]}"; do
        if [ -d "$src/$module" ]; then
            shopt -s nullglob
            local files=("$src/$module"/*)
            shopt -u nullglob
            if [ ${#files[@]} -gt 0 ]; then
                fs_copy "${files[@]}" "${TARGET_MAP[$module]}/" || return 1
            fi
            ok "Restored: $module"
        fi
    done

    return 0
}
