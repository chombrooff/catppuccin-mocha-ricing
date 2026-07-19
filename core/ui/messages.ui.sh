RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

log()  { echo -e "${CYAN}[INFO]${NC} $1"; }
ok()   { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
err()  { echo -e "${RED}[ERR]${NC} $1"; }

prompt_confirm() {
    local msg="${1:-Continue?}"
    echo -e -n "${YELLOW}$msg [Y/n]${NC} "
    read -r response
    case "$response" in
        [nN][oO]|[nN]) return 1 ;;
        *) return 0 ;;
    esac
}

print_header() {
    echo ""
    echo -e "${CYAN}╔══════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║   Catppuccin Mocha Ricing Installer  ║${NC}"
    echo -e "${CYAN}║   Arch Linux + Hyprland              ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════╝${NC}"
    echo ""
}

print_summary() {
    local results=("$@")
    echo ""
    echo -e "${BOLD}Installation Summary:${NC}"
    echo -e "${BOLD}────────────────────────────────────────${NC}"
    for result in "${results[@]}"; do
        echo -e "  $result"
    done
    echo ""
}
