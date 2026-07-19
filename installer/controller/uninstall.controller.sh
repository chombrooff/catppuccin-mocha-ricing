source "$SOURCE_DIR/core/model/paths.model.sh"
source "$SOURCE_DIR/core/service/backup.service.sh"
source "$SOURCE_DIR/core/ui/messages.ui.sh"
source "$SOURCE_DIR/installer/service/uninstall.service.sh"

parse_args() {
    local mode="interactive"

    for arg in "$@"; do
        case "$arg" in
            --help|-h)
                echo "Usage: bash uninstall.sh [options]"
                echo ""
                echo "Options:"
                echo "  --help, -h     Show this help"
                echo "  --prefix <dir> Specify install prefix (must match install.sh)"
                echo "  --dry-run      Show what would be removed without doing it"
                echo "  --force        Skip confirmation prompt"
                exit 0
                ;;
            --dry-run)
                mode="dry-run"
                ;;
            --force)
                mode="force"
                ;;
        esac
    done

    echo "$mode"
}

main() {
    local mode
    mode=$(parse_args "$@")

    if [ "$mode" = "interactive" ] || [ "$mode" = "force" ]; then
        uninstall_run "$mode"
    elif [ "$mode" = "dry-run" ]; then
        uninstall_run "dry-run"
    fi
}

main "$@"
