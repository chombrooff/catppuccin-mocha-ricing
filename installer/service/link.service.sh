link_install() {
    local src="$1"
    local dest="$2"
    local mode="${LINK_MODE:-copy}"

    while IFS= read -r -d '' item; do
        local name
        name=$(basename "$item")

        if [ "$mode" = "symlink" ]; then
            local link_path="$dest/$name"
            if [ -e "$link_path" ] || [ -L "$link_path" ]; then
                rm -rf "$link_path"
            fi
            ln -sf "$item" "$dest/"
        else
            if [ -d "$item" ]; then
                cp -r "$item" "$dest/"
            elif [ -f "$item" ]; then
                cp "$item" "$dest/"
            fi
        fi
    done < <(find "$src" -mindepth 1 -maxdepth 1 -print0)
}

link_remove() {
    local dest="$1"
    local mode="${LINK_MODE:-copy}"

    if [ ! -e "$dest" ]; then
        return 0
    fi

    if [ "$mode" = "symlink" ]; then
        while IFS= read -r -d '' link; do
            if [ -L "$link" ]; then
                rm "$link"
            fi
        done < <(find "$dest" -type l -print0)
    fi

    rm -rf "$dest"
}

link_entry_points() {
    local module="$1"
    local entry="${ENTRY_POINTS[$module]}"

    [ -z "$entry" ] && return 0

    local target="${entry%%=*}"
    local source="${entry#*=}"
    local source_path="${TARGET_MAP[$module]}/$source"

    if [ ! -f "$source_path" ]; then
        warn "Entry point source not found: $source_path"
        return 0
    fi

    mkdir -p "$(dirname "$target")"

    if [ -f "$target" ] || [ -L "$target" ]; then
        rm -f "$target"
    fi

    ln -sf "$source_path" "$target"
    ok "Entry point: $target → $source"
}

link_remove_entry_points() {
    for module in "${!ENTRY_POINTS[@]}"; do
        local entry="${ENTRY_POINTS[$module]}"
        local target="${entry%%=*}"

        if [ -L "$target" ]; then
            rm -f "$target"
        fi
    done
}
