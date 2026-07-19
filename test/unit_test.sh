#!/bin/bash
set -euo pipefail

PASS=0
FAIL=0
PACKAGE_DIR="$(cd "$(dirname "$0")/.." && pwd)"

log()  { echo -e "\033[0;36m[UNIT]\033[0m $1"; }
ok()   { echo -e "\033[0;32m  PASS\033[0m $1"; PASS=$((PASS + 1)); }
fail() { echo -e "\033[0;31m  FAIL\033[0m $1"; FAIL=$((FAIL + 1)); }

assert_eq() {
    local actual="$1" expected="$2" msg="$3"
    if [ "$actual" = "$expected" ]; then
        ok "$msg"
    else
        fail "$msg (expected: '$expected', got: '$actual')"
    fi
}

assert_contains() {
    local haystack="$1" needle="$2" msg="$3"
    if echo "$haystack" | grep -q "$needle"; then
        ok "$msg"
    else
        fail "$msg (expected to contain: '$needle')"
    fi
}

assert_true() {
    local msg="$1"
    shift
    if "$@"; then
        ok "$msg"
    else
        fail "$msg"
    fi
}

assert_false() {
    local msg="$1" rc=0
    shift
    "$@" || rc=$?
    if [ "$rc" -ne 0 ]; then
        ok "$msg"
    else
        fail "$msg"
    fi
}

echo ""
echo -e "\033[1;36m══════════════════════════════════════════════╗"
echo "  Catppuccin Mocha — Unit Tests"
echo -e "══════════════════════════════════════════════╝\033[0m"
echo ""

log "=== Core: paths.model.sh ==="
export PREFIX="/tmp/test-prefix"
source "$PACKAGE_DIR/core/model/paths.model.sh"
assert_eq "$CONFIG_DIR" "/tmp/test-prefix/.config" "CONFIG_DIR honors PREFIX"
assert_eq "$BACKUP_DIR" "/tmp/test-prefix/dotfiles-backup" "BACKUP_DIR honors PREFIX"

export PREFIX=""
source "$PACKAGE_DIR/core/model/paths.model.sh"
assert_eq "$CONFIG_DIR" "$HOME/.config" "CONFIG_DIR defaults to \$HOME/.config"

assert_contains "${MODULES[*]}" "hypr" "MODULES contains hypr"
assert_contains "${MODULES[*]}" "waybar" "MODULES contains waybar"
assert_contains "${MODULES[*]}" "gtk" "MODULES contains gtk"

assert_contains "${REQUIRED_PACKAGES[*]}" "hyprland" "REQUIRED_PACKAGES contains hyprland"
assert_contains "${REQUIRED_PACKAGES[*]}" "ttf-jetbrains-mono-nerd" "REQUIRED_PACKAGES contains font"

log "=== Core: filesystem.repo.sh ==="
source "$PACKAGE_DIR/core/repository/filesystem.repo.sh"

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

echo "hello" > "$tmpdir/source.txt"
fs_copy "$tmpdir/source.txt" "$tmpdir/dest.txt"
assert_true "fs_copy copies file" test -f "$tmpdir/dest.txt"
assert_eq "$(cat "$tmpdir/dest.txt")" "hello" "fs_copy preserves content"

mkdir -p "$tmpdir/sub"
echo "nested" > "$tmpdir/sub/nested.txt"
fs_copy "$tmpdir/sub" "$tmpdir/sub_copy"
assert_true "fs_copy copies directory" test -f "$tmpdir/sub_copy/nested.txt"

fs_move "$tmpdir/source.txt" "$tmpdir/moved.txt"
assert_true "fs_move moves file" test -f "$tmpdir/moved.txt"
assert_false "fs_move removes original" test -f "$tmpdir/source.txt"

echo "abc" > "$tmpdir/a.txt"
echo "abc" > "$tmpdir/b.txt"
echo "xyz" > "$tmpdir/c.txt"
assert_true "fs_compare identical files" fs_compare "$tmpdir/a.txt" "$tmpdir/b.txt"
assert_false "fs_compare different files" fs_compare "$tmpdir/a.txt" "$tmpdir/c.txt"

md5_val=$(fs_md5 "$tmpdir/a.txt")
expected_val=$(md5sum "$tmpdir/a.txt" | cut -d' ' -f1)
assert_eq "$md5_val" "$expected_val" "fs_md5 computes correct hash"

md5_empty=$(fs_md5 "$tmpdir/nonexistent.txt" 2>/dev/null || true)
assert_eq "$md5_empty" "" "fs_md5 returns empty for missing file"

fs_list "$tmpdir" "*.txt" > /dev/null
assert_true "fs_list lists files" test "$(fs_list "$tmpdir" "*.txt" | wc -l)" -ge 3

log "=== Core: messages.ui.sh ==="
source "$PACKAGE_DIR/core/ui/messages.ui.sh"
# reassert unit test helpers after messages.ui.sh overwrites ok/log
ok()   { echo -e "\033[0;32m  PASS\033[0m $1"; PASS=$((PASS + 1)); }
log()  { echo -e "\033[0;36m[UNIT]\033[0m $1"; }
assert_contains "$(print_header 2>&1)" "Catppuccin" "print_header contains Catppuccin"
assert_contains "$(echo -e "${GREEN}test${NC}")" "test" "GREEN color defined"

log "=== Installer: link.service.sh ==="
export LINK_MODE="copy"
source "$PACKAGE_DIR/installer/service/link.service.sh"

tmp_install=$(mktemp -d)
trap 'rm -rf "$tmpdir" "$tmp_install"' EXIT

echo "config1" > "$tmp_install/foo.conf"
mkdir -p "$tmp_install/subdir"
echo "config2" > "$tmp_install/subdir/bar.conf"

tmp_dest=$(mktemp -d)
trap 'rm -rf "$tmpdir" "$tmp_install" "$tmp_dest"' EXIT

link_install "$tmp_install" "$tmp_dest"
assert_true "link_install copies files" test -f "$tmp_dest/foo.conf"
assert_true "link_install copies subdirectories" test -f "$tmp_dest/subdir/bar.conf"
assert_eq "$(cat "$tmp_dest/foo.conf")" "config1" "link_install preserves content"

rm -rf "$tmp_dest" && mkdir -p "$tmp_dest"
export LINK_MODE="symlink"
link_install "$tmp_install" "$tmp_dest"
assert_true "link_install creates symlinks" test -L "$tmp_dest/foo.conf"
assert_eq "$(readlink "$tmp_dest/foo.conf")" "$tmp_install/foo.conf" "link_install symlink target correct"

log "=== Packages: packages.model.sh ==="
source "$PACKAGE_DIR/packages/model/packages.model.sh"
assert_contains "${PACKAGE_GROUPS[*]}" "hyprland" "PACKAGE_GROUPS contains core DE"
assert_contains "${PACKAGE_GROUPS[*]}" "firefox" "PACKAGE_GROUPS contains apps"

log "=== Validation: validation.util.sh ==="
export PREFIX=""
source "$PACKAGE_DIR/core/utility/validation.util.sh"
assert_true "validate_theme passes for valid dir" validate_theme "$PACKAGE_DIR"
assert_false "validate_theme fails for missing dir" validate_theme "/nonexistent"

echo ""
echo -e "\033[1;36m══════════════════════════════════════════════╗"
echo -e "  Unit Test Results:  PASS=$PASS  FAIL=$FAIL"
echo -e "══════════════════════════════════════════════╝\033[0m"
echo ""

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
