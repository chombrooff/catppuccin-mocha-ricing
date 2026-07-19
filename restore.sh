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
        --help|-h)
            echo "Usage: bash restore.sh [options]"
            echo ""
            echo "Options:"
            echo "  --prefix <dir>  Restore to custom prefix (default: \$HOME/.config)"
            echo "  <timestamp>     Restore specific backup (interactive if omitted)"
            echo "  --help, -h      Show this help"
            exit 0
            ;;
        *)
            if [ -z "${TIMESTAMP:-}" ]; then
                TIMESTAMP="$1"
                shift
            else
                echo "Unknown option: $1"
                exit 1
            fi
            ;;
    esac
done

export PREFIX

if [ ! -d "$SOURCE_DIR/installer" ]; then
    echo "ERROR: Installer module not found at $SOURCE_DIR/installer" >&2
    exit 1
fi

source "$SOURCE_DIR/core/utility/validation.util.sh"

if ! validate_prefix "$PREFIX"; then
    exit 1
fi

source "$SOURCE_DIR/installer/service/restore.service.sh"