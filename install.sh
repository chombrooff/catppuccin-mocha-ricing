#!/bin/bash
set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "$0")" && pwd)"
PREFIX=""
LINK_MODE="copy"

while [ $# -gt 0 ]; do
    case "$1" in
        --prefix)
            PREFIX="$2"
            shift 2
            ;;
        --symlink)
            LINK_MODE="symlink"
            shift
            ;;
        --copy)
            LINK_MODE="copy"
            shift
            ;;
        --help|-h)
            echo "Usage: bash install.sh [options]"
            echo ""
            echo "Options:"
            echo "  --prefix <dir>   Install to custom prefix (default: \$HOME/.config)"
            echo "  --symlink        Use symlinks instead of copy"
            echo "  --copy           Use copy (default)"
            echo "  --help, -h       Show this help"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: bash install.sh [--prefix <dir>] [--symlink] [--copy]"
            exit 1
            ;;
    esac
done

export PREFIX
export LINK_MODE

source "$SOURCE_DIR/core/ui/messages.ui.sh"
source "$SOURCE_DIR/core/utility/validation.util.sh"

if ! validate_prefix "$PREFIX"; then
    exit 1
fi

if [ ! -d "$SOURCE_DIR/installer" ]; then
    err "Installer module not found at $SOURCE_DIR/installer"
    exit 1
fi

source "$SOURCE_DIR/installer/controller/installer.controller.sh"
