# Master Plan: Catppuccin Mocha Ricing — Arch Linux + Hyprland

## System Requirements

- **Arch Linux** with Hyprland (tested on Hyprland 0.55+)
- **Packages to install**:
  ```
  hyprland waybar rofi kitty swaync wlogout hyprpaper papirus-icon-theme bibata-cursor-theme ttf-jetbrains-mono-nerd
  ```
- **Display**: Any resolution (auto-detected), HiDPI supported

---

## Specification

| Aspek | Detail |
|-------|--------|
| **Palette** | Catppuccin Mocha (base `#1e1e2e`, text `#cdd6f4`, accent mauve `#cba6f7`) |
| **Corner rounding** | 12px (windows, waybar, rofi, notifications, wlogout) |
| **Gaps** | In: 4px, Out: 8px |
| **Blur** | Enabled, 6 size, 3 passes |
| **Animasi** | Bezier curve, slide windows/workspaces, 4 segmen |
| **Font** | JetBrainsMono Nerd Font 12px |
| **Ikon** | Papirus-Dark |
| **Cursor** | Bibata-Modern-Classic |
| **Terminal opacity** | 0.88 with blur |

---

## Directory Structure Output

```
~/.config/
├── hypr/
│   ├── hyprland.conf       # Main config — sources all below
│   ├── looknfeel.conf      # rounding=12, blur, gaps, animations
│   ├── bindings.conf       # All keybindings
│   ├── autostart.conf      # waybar, swaync, hyprpaper, polkit
│   ├── monitors.conf       # Display configuration
│   ├── envs.conf           # Wayland environment variables
│   ├── input.conf          # Keyboard & touchpad
│   ├── hyprpaper.conf      # Wallpaper manager
│   └── scripts/
│       ├── wallpaper.sh         # Random wallpaper on startup
│       └── change-wallpaper.sh  # Cycle wallpapers (keybind-ready)
├── waybar/
│   ├── config.jsonc        # Bar modules & layout
│   └── style.css           # Catppuccin Mocha CSS
├── rofi/
│   ├── config.rasi         # Launcher config (drun, run, window)
│   └── catppuccin.rasi     # Catppuccin color theme
├── swaync/
│   ├── config.json         # Notification center config
│   └── style.css           # Catppuccin styling
├── wlogout/
│   ├── layout              # 6-button power menu
│   └── style.css           # Catppuccin styling
├── kitty/
│   └── kitty.conf          # Catppuccin Mocha terminal theme
└── gtk-3.0/
    └── settings.ini        # GTK theme, icons, cursor, font
```

---

## Component Details

### 1. Hyprland

- **Window borders**: Active = maue (`#cba6f7`), Inactive = surface0 (`#313244`)
- **Gaps**: 4px inside, 8px outside
- **Rounding**: 12px all windows
- **Blur**: Size 6, passes 3, contrast 0.7
- **Animations**: Custom bezier 0.05/0.9/0.1/1.05, slide for windows, slidevert for workspaces
- **Shadow**: Range 20, render power 3, 60% opacity
- **VRR**: Enabled (adaptive sync)
- **Swallow**: Kitty windows swallowed

### 2. Waybar

- **Position**: Top, full width, 30px height
- **Background**: `@base` at 85% opacity, bottom border `@surface0`, bottom corners rounded 12px
- **Modules**:
  - Left: Workspaces (numbered, active = mauve bg)
  - Center: Clock (with calendar tooltip on hover)
  - Right: Weather, tray, bluetooth, network, audio, CPU, memory, battery
- **Interactive**: Click modules to open relevant apps (btop, pavucontrol, nm-connection-editor, etc.)

### 3. Rofi

- **Modes**: drun (app launcher), run (command), window (window switcher)
- **Size**: 600px wide, 12 lines, 2 columns
- **Style**: Catppuccin Mocha, 12px border radius, no border, floating
- **Search**: Placeholder "Search", cursor = mauve
- **Shortcut**: `SUPER + Space` launcher, `SUPER + Shift + Space` window switcher

### 4. Kitty Terminal

- **Font**: JetBrainsMono Nerd Font 11px
- **Opacity**: 0.88 with `background_blur 6`
- **Tab bar**: Bottom, powerline style, slanted, Catppuccin colors
- **Catppuccin Mocha**: Full 16-color ANSI palette

### 5. SwayNC (Notification Center)

- **Position**: Top-right
- **Width**: 400px
- **Timeout**: 2s normal, 2s low, 0s critical
- **Blurred backdrop**: 95% opacity base background
- **Widgets**: Title + clear-all, notifications group, DND toggle, volume slider, MPRIS player, buttons grid (poweroff, reboot, logout, lock, workspace 1, screenshot)

### 6. Wlogout (Power Menu)

- **Layout**: 6 buttons — lock, logout, reboot, shutdown, hibernate, sleep
- **Size**: 100×100px per button
- **Style**: Catppuccin Mocha, 12px radius, hover = mauve border
- **Backdrop**: Blurred 80% opacity base
- **Shortcut**: `SUPER + Shift + E`

### 7. Hyprpaper (Wallpaper)

- **Auto-start**: Picks random wallpaper from `~/.config/hypr/hyprpaper.d/`
- **Cycle script**: `change-wallpaper.sh` cycles to next wallpaper
- **Recommended**: Download from [catppuccin/wallpapers](https://github.com/catppuccin/wallpapers)

---

## Keybindings

| Binding | Action |
|---------|--------|
| `SUPER + Return` | Terminal (kitty) |
| `SUPER + Space` | Application launcher |
| `SUPER + Shift + Space` | Window switcher |
| `SUPER + Shift + E` | Power menu |
| `SUPER + Q` | Close window |
| `SUPER + F` | Fullscreen |
| `SUPER + T` | Toggle float |
| `SUPER + P` | Pseudo tile |
| `SUPER + J` | Toggle split |
| `SUPER + L` | Lock screen |
| `SUPER + W` | Browser |
| `SUPER + E` | File manager |
| `SUPER + V` | Clipboard |
| `SUPER + 1-0` | Switch workspace |
| `SUPER + Shift + 1-0` | Move window to workspace |
| `SUPER + hjkl` | Move focus |
| `SUPER + Shift + hjkl` | Move window |
| `SUPER + mouse_down/up` | Scroll workspaces |
| `print / Shift+print` | Screenshot |

---

## Performance Optimizations

| Setting | Value | Benefit |
|---------|-------|---------|
| Blur passes | 3 | Saves GPU vs 6+ |
| Blur size | 6 | Balanced quality/performance |
| Shadow range | 20 | Soft but not expensive |
| VRR (adaptive sync) | enabled | Zero tearing, lower power |
| Mouse drag animation | disabled | Less CPU during drag |
| Animation segments | 4 | Smooth but not heavy |
| Notification timeout | 2s | Less clutter |
| Waybar CPU interval | 5s | Adequate, not polling too fast |

---

## Installation

```bash
# 1. Install packages
sudo pacman -S hyprland waybar rofi kitty swaync wlogout hyprpaper papirus-icon-theme bibata-cursor-theme ttf-jetbrains-mono-nerd

# 2. Run installer (backs up existing configs first)
chmod +x install.sh
./install.sh
```

## Backup & Restore

- **Backup location**: `~/dotfiles-backup/<timestamp>/`
- **Restore**: Run `./restore.sh` and select a timestamp
- **Manual**: `./install.sh` always creates backup before overwriting

---

## Wallpaper Recommendations

1. **Official**: `git clone https://github.com/catppuccin/wallpapers ~/Pictures/wallpapers`
2. **Gradient**: `magick -size 2560x1440 gradient:'#1e1e2e'-'#11111b' mocha-gradient.png`
3. **Place in**: `~/.config/hypr/hyprpaper.d/`

---

## Design Principles

1. **Consistency**: Every component uses the same Catppuccin Mocha palette
2. **Minimalism**: No unnecessary visual noise, clean spacing
3. **Functionality**: Every click/tap opens relevant settings
4. **Performance**: Optimized for smooth 60+fps on modern hardware
5. **Discovery**: Keybindings and click actions are discoverable through tooltips

---

## Arsitektur Modular

Proyek ini mengikuti prinsip **modularitas ketat**:

| Aturan | Spesifikasi |
|--------|-------------|
| **Batas file** | Maksimal 300–500 baris per file |
| **Pemecahan file** | Jika >500 baris, pecah berdasarkan Single Responsibility Principle |
| **Struktur modul** | Setiap modul punya folder sendiri: `model/`, `service/`, `repository/`, `controller/`, `ui/`, `utility/` |
| **Panjang fungsi** | Maksimal 30–50 baris per fungsi |
| **Pemisahan fitur** | Satu file tidak boleh menggabungkan fitur yang tidak berkaitan |
| **Refactoring** | Pecah file besar secara bertahap tanpa mengubah perilaku |

### Struktur Modul Akhir

```
catppuccin-mocha-ricing/
├── masterplan.md, PRD.md, README.md, install.sh, restore.sh
├── core/        # Backup service, filesystem, path constants
├── hypr/        # Hyprland: palette, decoration, animation, layout, input, bindings
├── waybar/      # Waybar: left/center/right modules, CSS per komponen
├── rofi/        # Rofi: colors, window, inputbar, listview, element styling
├── swaync/      # SwayNC: notification, control-center, widget styling
├── wlogout/     # Wlogout: layout, button, backdrop styling
├── kitty/       # Kitty: palette, tabbar, cursor styling
├── gtk/         # GTK: theme settings applier
└── wallpaper/   # Hyprpaper: random/cycle service, image repository
```

Lihat `PRD.md` untuk detail arsitektur modular lengkap.
