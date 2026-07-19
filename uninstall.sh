#!/bin/bash
set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "$0")" && pwd)"
PREFIX=""

while [ $# -gt 0 ]; do
    case "$1" in
        --prefix)
            PREFIX="$2"
            shift 2
            ;;
        --help|-h|--dry-run|--force)
            break
            ;;
        *)
            break
            ;;
    esac
done

export PREFIX

if [ ! -d "$SOURCE_DIR/installer" ]; then
    echo "ERROR: Installer module not found at $SOURCE_DIR/installer" >&2
    exit 1
fi

source "$SOURCE_DIR/installer/controller/uninstall.controller.sh" "$@"
