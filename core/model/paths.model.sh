CONFIG_DIR="${PREFIX:-$HOME}/.config"
BACKUP_DIR="${PREFIX:-$HOME}/dotfiles-backup"
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

MODULES=(hypr waybar rofi swaync wlogout kitty gtk wallpaper)

declare -A TARGET_MAP
TARGET_MAP[hypr]="$CONFIG_DIR/hypr"
TARGET_MAP[waybar]="$CONFIG_DIR/waybar"
TARGET_MAP[rofi]="$CONFIG_DIR/rofi"
TARGET_MAP[swaync]="$CONFIG_DIR/swaync"
TARGET_MAP[wlogout]="$CONFIG_DIR/wlogout"
TARGET_MAP[kitty]="$CONFIG_DIR/kitty"
TARGET_MAP[gtk]="$CONFIG_DIR/gtk-3.0"
TARGET_MAP[wallpaper]="$CONFIG_DIR/hypr"

# Entry point symlinks: tool config files that tools expect at specific paths
# Format: "target_path=relative_source_path_in_module"
declare -A ENTRY_POINTS
ENTRY_POINTS[hypr]="$CONFIG_DIR/hypr/hyprland.conf=controller/hyprland.controller.conf"
ENTRY_POINTS[waybar]="$CONFIG_DIR/waybar/config.jsonc=controller/waybar.controller.jsonc"
ENTRY_POINTS[rofi]="$CONFIG_DIR/rofi/config.rasi=controller/rofi.controller.rasi"
ENTRY_POINTS[kitty]="$CONFIG_DIR/kitty/kitty.conf=controller/kitty.controller.conf"
ENTRY_POINTS[swaync]="$CONFIG_DIR/swaync/config.json=controller/swaync.controller.json"
ENTRY_POINTS[wlogout]="$CONFIG_DIR/wlogout/layout=controller/layout.json"
ENTRY_POINTS[wallpaper]="$CONFIG_DIR/hypr/hyprpaper.conf=controller/hyprpaper.controller.conf"

REQUIRED_PACKAGES=(
  hyprland waybar rofi kitty swaync wlogout
  hyprpaper papirus-icon-theme bibata-cursor-theme
  ttf-jetbrains-mono-nerd
)
