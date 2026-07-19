fs_copy() {
    local src="$1"
    local dest="$2"

    if [ ! -e "$src" ]; then
        echo "ERROR: Source not found: $src" >&2
        return 1
    fi

    mkdir -p "$(dirname "$dest")"
    cp -r "$src" "$dest" 2>/dev/null || {
        echo "ERROR: Failed to copy $src -> $dest" >&2
        return 1
    }

    return 0
}

fs_move() {
    local src="$1"
    local dest="$2"

    if [ ! -e "$src" ]; then
        echo "ERROR: Source not found: $src" >&2
        return 1
    fi

    mkdir -p "$(dirname "$dest")"
    mv "$src" "$dest" 2>/dev/null || {
        echo "ERROR: Failed to move $src -> $dest" >&2
        return 1
    }

    return 0
}

fs_compare() {
    local file_a="$1"
    local file_b="$2"

    if [ ! -f "$file_a" ] || [ ! -f "$file_b" ]; then
        return 1
    fi

    diff -q "$file_a" "$file_b" >/dev/null 2>&1
}

fs_md5() {
    local file="$1"

    if [ ! -f "$file" ]; then
        echo ""
        return 1
    fi

    md5sum "$file" | cut -d' ' -f1
}

fs_list() {
    local dir="$1"
    local pattern="${2:-*}"

    if [ ! -d "$dir" ]; then
        return 1
    fi

    find "$dir" -maxdepth 1 -type f -name "$pattern" 2>/dev/null | sort
}
