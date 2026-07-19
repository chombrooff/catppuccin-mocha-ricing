#!/bin/bash
set -euo pipefail

PASS=0
FAIL=0
PACKAGE_DIR="$(cd "$(dirname "$0")/.." && pwd)"

log()  { echo -e "\033[0;36m[TEST]\033[0m $1"; }
ok()   { echo -e "\033[0;32m  PASS\033[0m $1"; PASS=$((PASS + 1)); }
fail() { echo -e "\033[0;31m  FAIL\033[0m $1"; FAIL=$((FAIL + 1)); }

expect_file() {
    if [ -f "$1" ]; then ok "File exists: $1"; else fail "Missing file: $1"; fi
}

expect_dir() {
    if [ -d "$1" ]; then ok "Directory exists: $1"; else fail "Missing directory: $1"; fi
}

expect_shebang() {
    local file="$1"
    local expected="${2:-#!/bin/bash}"
    if head -1 "$file" 2>/dev/null | grep -q "$expected"; then
        ok "Shebang: $file"
    else
        fail "Missing/wrong shebang: $file (expected: $expected)"
    fi
}

echo ""
echo -e "\033[1;36m══════════════════════════════════════════════╗"
echo "  Catppuccin Mocha Ricing — Integration Tests"
echo -e "══════════════════════════════════════════════╝\033[0m"
echo ""

log "=== Directory Structure ==="
expect_dir "$PACKAGE_DIR/core/model"
expect_dir "$PACKAGE_DIR/core/service"
expect_dir "$PACKAGE_DIR/core/repository"
expect_dir "$PACKAGE_DIR/core/ui"
expect_dir "$PACKAGE_DIR/core/utility"
expect_dir "$PACKAGE_DIR/hypr/model"
expect_dir "$PACKAGE_DIR/hypr/service"
expect_dir "$PACKAGE_DIR/hypr/controller"
expect_dir "$PACKAGE_DIR/hypr/utility"
expect_dir "$PACKAGE_DIR/waybar/model"
expect_dir "$PACKAGE_DIR/waybar/service"
expect_dir "$PACKAGE_DIR/waybar/controller"
expect_dir "$PACKAGE_DIR/waybar/ui"
expect_dir "$PACKAGE_DIR/waybar/utility"
expect_dir "$PACKAGE_DIR/rofi/model"
expect_dir "$PACKAGE_DIR/rofi/controller"
expect_dir "$PACKAGE_DIR/rofi/ui"
expect_dir "$PACKAGE_DIR/kitty/model"
expect_dir "$PACKAGE_DIR/kitty/controller"
expect_dir "$PACKAGE_DIR/kitty/ui"
expect_dir "$PACKAGE_DIR/swaync/model"
expect_dir "$PACKAGE_DIR/swaync/controller"
expect_dir "$PACKAGE_DIR/swaync/ui"
expect_dir "$PACKAGE_DIR/wlogout/model"
expect_dir "$PACKAGE_DIR/wlogout/controller"
expect_dir "$PACKAGE_DIR/wlogout/ui"
expect_dir "$PACKAGE_DIR/wallpaper/controller"
expect_dir "$PACKAGE_DIR/wallpaper/service"
expect_dir "$PACKAGE_DIR/gtk/model"
expect_dir "$PACKAGE_DIR/gtk/controller"
expect_dir "$PACKAGE_DIR/installer/controller"
expect_dir "$PACKAGE_DIR/installer/service"
expect_dir "$PACKAGE_DIR/installer/utility"
expect_dir "$PACKAGE_DIR/test"

echo ""
log "=== Core Module Files ==="
expect_file "$PACKAGE_DIR/core/model/paths.model.sh"
expect_file "$PACKAGE_DIR/core/service/backup.service.sh"
expect_file "$PACKAGE_DIR/core/repository/filesystem.repo.sh"
expect_file "$PACKAGE_DIR/core/ui/messages.ui.sh"
expect_file "$PACKAGE_DIR/core/utility/validation.util.sh"

echo ""
log "=== Hyprland Files ==="
expect_file "$PACKAGE_DIR/hypr/model/palette.model.conf"
expect_file "$PACKAGE_DIR/hypr/service/decoration.service.conf"
expect_file "$PACKAGE_DIR/hypr/service/animation.service.conf"
expect_file "$PACKAGE_DIR/hypr/service/layout.service.conf"
expect_file "$PACKAGE_DIR/hypr/controller/hyprland.controller.conf"
expect_file "$PACKAGE_DIR/hypr/controller/input.controller.conf"
expect_file "$PACKAGE_DIR/hypr/controller/monitor.controller.conf"
expect_file "$PACKAGE_DIR/hypr/controller/env.controller.conf"
expect_file "$PACKAGE_DIR/hypr/controller/bind.controller.conf"
expect_file "$PACKAGE_DIR/hypr/controller/autostart.controller.conf"
expect_file "$PACKAGE_DIR/hypr/utility/xdg.util.conf"

echo ""
log "=== Waybar Files ==="
expect_file "$PACKAGE_DIR/waybar/model/colors.model.css"
expect_file "$PACKAGE_DIR/waybar/service/left.service.jsonc"
expect_file "$PACKAGE_DIR/waybar/service/center.service.jsonc"
expect_file "$PACKAGE_DIR/waybar/service/right.service.jsonc"
expect_file "$PACKAGE_DIR/waybar/controller/waybar.controller.jsonc"
expect_file "$PACKAGE_DIR/waybar/style.css"
expect_file "$PACKAGE_DIR/waybar/ui/bar.ui.css"
expect_file "$PACKAGE_DIR/waybar/ui/workspace.ui.css"
expect_file "$PACKAGE_DIR/waybar/ui/modules.ui.css"
expect_file "$PACKAGE_DIR/waybar/ui/tooltip.ui.css"



echo ""
log "=== Rofi Files ==="
expect_file "$PACKAGE_DIR/rofi/model/colors.model.rasi"
expect_file "$PACKAGE_DIR/rofi/controller/rofi.controller.rasi"
expect_file "$PACKAGE_DIR/rofi/ui/window.ui.rasi"
expect_file "$PACKAGE_DIR/rofi/ui/inputbar.ui.rasi"
expect_file "$PACKAGE_DIR/rofi/ui/listview.ui.rasi"
expect_file "$PACKAGE_DIR/rofi/ui/element.ui.rasi"

echo ""
log "=== Kitty Files ==="
expect_file "$PACKAGE_DIR/kitty/model/palette.model.conf"
expect_file "$PACKAGE_DIR/kitty/controller/kitty.controller.conf"

echo ""
log "=== SwayNC Files ==="
expect_file "$PACKAGE_DIR/swaync/model/colors.model.css"
expect_file "$PACKAGE_DIR/swaync/controller/swaync.controller.json"
expect_file "$PACKAGE_DIR/swaync/ui/notification.ui.css"
expect_file "$PACKAGE_DIR/swaync/ui/control-center.ui.css"
expect_file "$PACKAGE_DIR/swaync/ui/widget-dnd.ui.css"
expect_file "$PACKAGE_DIR/swaync/ui/widget-volume.ui.css"

expect_file "$PACKAGE_DIR/swaync/ui/widget-buttons.ui.css"

echo ""
log "=== Wlogout Files ==="
expect_file "$PACKAGE_DIR/wlogout/model/colors.model.css"
expect_file "$PACKAGE_DIR/wlogout/controller/layout.json"
expect_file "$PACKAGE_DIR/wlogout/ui/button.ui.css"
expect_file "$PACKAGE_DIR/wlogout/ui/backdrop.ui.css"

echo ""
log "=== Wallpaper Files ==="
expect_file "$PACKAGE_DIR/wallpaper/controller/hyprpaper.controller.conf"


echo ""
log "=== GTK Files ==="
expect_file "$PACKAGE_DIR/gtk/model/theme.model.ini"
expect_file "$PACKAGE_DIR/gtk/controller/gtk.controller.sh"

echo ""
log "=== Installer Files ==="
expect_file "$PACKAGE_DIR/installer/controller/installer.controller.sh"
expect_file "$PACKAGE_DIR/installer/service/dependency.service.sh"
expect_file "$PACKAGE_DIR/installer/service/link.service.sh"
expect_file "$PACKAGE_DIR/installer/service/restore.service.sh"
expect_file "$PACKAGE_DIR/installer/service/uninstall.service.sh"
expect_file "$PACKAGE_DIR/installer/controller/uninstall.controller.sh"

echo ""
log "=== Packages Module ==="
expect_dir "$PACKAGE_DIR/packages/model"
expect_dir "$PACKAGE_DIR/packages/service"
expect_file "$PACKAGE_DIR/packages/model/packages.model.sh"
expect_file "$PACKAGE_DIR/packages/service/packages.service.sh"

echo ""
log "=== Entry Points ==="
expect_file "$PACKAGE_DIR/install.sh"
expect_file "$PACKAGE_DIR/restore.sh"
expect_file "$PACKAGE_DIR/uninstall.sh"
expect_shebang "$PACKAGE_DIR/install.sh"
expect_shebang "$PACKAGE_DIR/restore.sh"
expect_shebang "$PACKAGE_DIR/uninstall.sh"

echo ""
log "=== Test Files ==="
expect_file "$PACKAGE_DIR/test/integration_test.sh"
expect_file "$PACKAGE_DIR/test/unit_test.sh"

echo ""
log "=== Config Structure Validation ==="
if grep -q "source =" "$PACKAGE_DIR/hypr/controller/hyprland.controller.conf"; then
    ok "Hyprland controller uses source= includes"
else
    fail "Hyprland controller missing source= includes"
fi

if grep -q "@theme" "$PACKAGE_DIR/rofi/controller/rofi.controller.rasi"; then
    ok "Rofi controller has @theme includes"
else
    fail "Rofi controller missing @theme includes"
fi

if grep -q "@import" "$PACKAGE_DIR/waybar/style.css"; then
    ok "Waybar style.css has @import directives"
else
    fail "Waybar style.css missing @import directives"
fi

if grep -q "include" "$PACKAGE_DIR/kitty/controller/kitty.controller.conf"; then
    ok "Kitty controller has include directives"
else
    fail "Kitty controller missing include directives"
fi

if grep -q "@define-color" "$PACKAGE_DIR/swaync/model/colors.model.css"; then
    ok "SwayNC colors model has @define-color"
else
    fail "SwayNC colors model missing @define-color"
fi

if grep -q "has_backup" "$PACKAGE_DIR/core/service/backup.service.sh"; then
    ok "Backup service has has_backup function"
else
    fail "Backup service missing has_backup function"
fi

if grep -q "uninstall_remove_configs" "$PACKAGE_DIR/installer/service/uninstall.service.sh"; then
    ok "Uninstall service has uninstall_remove_configs"
else
    fail "Uninstall service missing uninstall_remove_configs"
fi

if grep -q "dry-run" "$PACKAGE_DIR/installer/controller/uninstall.controller.sh"; then
    ok "Uninstall controller supports --dry-run flag"
else
    fail "Uninstall controller missing --dry-run"
fi

echo ""
log "=== Task 1: Wlogout layout renamed ==="
if [ ! -f "$PACKAGE_DIR/wlogout/controller/layout.controller" ] && [ -f "$PACKAGE_DIR/wlogout/controller/layout.json" ]; then
    ok "wlogout layout.controller renamed to layout.json"
else
    fail "wlogout layout.controller still exists or layout.json missing"
fi

echo ""
log "=== Task 2: --prefix flag ==="
if grep -q "PREFIX" "$PACKAGE_DIR/install.sh" && grep -q "PREFIX" "$PACKAGE_DIR/core/model/paths.model.sh"; then
    ok "install.sh supports --prefix flag with CONFIG_DIR override"
else
    fail "install.sh missing --prefix flag"
fi

echo ""
log "=== Task 3: Symlink option ==="
if grep -q "symlink" "$PACKAGE_DIR/install.sh" && grep -q "LINK_MODE" "$PACKAGE_DIR/installer/service/link.service.sh"; then
    ok "install.sh supports --symlink option"
else
    fail "install.sh missing --symlink support"
fi

echo ""
log "=== Task 4: Wallpaper preload in autostart ==="
if grep -q "hyprctl hyprpaper preload" "$PACKAGE_DIR/hypr/controller/autostart.controller.conf"; then
    ok "autostart has wallpaper preload"
else
    fail "autostart missing wallpaper preload"
fi

echo ""
log "=== Task 5: Unit tests ==="
if [ -f "$PACKAGE_DIR/test/unit_test.sh" ]; then
    ok "unit_test.sh exists"
else
    fail "unit_test.sh missing"
fi

echo ""
log "=== Task 6: Packages module ==="
if grep -q "PACKAGE_GROUPS" "$PACKAGE_DIR/packages/model/packages.model.sh" && grep -q "package_install" "$PACKAGE_DIR/packages/service/packages.service.sh"; then
    ok "packages module has model and service"
else
    fail "packages module incomplete"
fi

echo ""
log "=== Code Smell Fix: backup_names removed ==="
if grep -q "backup_names" "$PACKAGE_DIR/installer/service/restore.service.sh"; then
    fail "restore.service.sh still has unused backup_names"
else
    ok "restore.service.sh no longer has unused backup_names"
fi

echo ""
log "=== File Size Check (max 500 lines each) ==="
find "$PACKAGE_DIR" -name '*.sh' -o -name '*.conf' -o -name '*.css' -o -name '*.rasi' -o -name '*.jsonc' -o -name '*.json' -o -name '*.ini' 2>/dev/null | while read -r f; do
    lines=$(wc -l < "$f")
    if [ "$lines" -gt 500 ]; then
        fail "File exceeds 500 lines: $f ($lines lines)"
    fi
done

echo ""
echo -e "\033[1;36m══════════════════════════════════════════════╗"
echo -e "  Results:  PASS=$PASS  FAIL=$FAIL"
echo -e "══════════════════════════════════════════════╝\033[0m"
echo ""

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
