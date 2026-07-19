# Catppuccin Mocha Ricing — Minimal & Elegant

Minimal, clean, intentional desktop environment for Arch Linux + Hyprland. Terinspirasi dari [saatvik333/hyprland-dotfiles](https://github.com/saatvik333/hyprland-dotfiles), [linuxmobile/hyprland-dots](https://github.com/linuxmobile/hyprland-dots), dan [petit-rice](https://github.com/alaminedione/petit-rice).

## Filosofi

- **Less is more** — setiap elemen karena fungsi, bukan hiasan
- **Visual rest** — muted contrast, low saturation, mata tidak cepat lelah
- **No noise** — tanpa transparansi/glassy berlebihan, flat dengan depth minimal
- **Subtle over flashy** — hover effects subtle, easing smooth, tanpa gradien

## Components

| Komponen | Peran | Detail |
|----------|-------|--------|
| **Hyprland** | Window manager | rounding=8px, blur 1 pass, border 1px, anim 3 segmen |
| **Waybar** | Status bar | 6 modules: workspaces, clock, cpu, memory, network, audio |
| **Rofi** | App launcher | 500px, single column, text-only |
| **Kitty** | Terminal | opacity 0.95, no tab bar |
| **SwayNC** | Notification center | 380px, timeout 3s, no MPRIS |
| **Wlogout** | Power menu | 4 buttons: lock, logout, reboot, shutdown |
| **Hyprpaper** | Wallpaper | static gradient, auto-installed |

## Quick Install

```bash
git clone https://github.com/chombrooff/catppuccin-mocha-ricing.git
cd catppuccin-mocha-ricing
bash install.sh
```

## Install Options

```bash
bash install.sh                    # copy mode (default)
bash install.sh --symlink          # symlink mode (perubahan langsung teraplikasi)
bash install.sh --prefix ~/custom  # custom prefix
```

Installer otomatis:
- Backup config existing (timestamp-based)
- Install semua config + entry point symlinks
- Setup Hyprland session untuk SDDM/GDM
- Opsi TTY auto-start (login di tty1 → langsung Hyprland)
- Apply GTK theme, cursor, icon theme
- Install wallpaper ke `~/.config/hypr/hyprpaper.d/default.png`

## Uninstall

```bash
./uninstall.sh                  # interactive + backup prompt
./uninstall.sh --dry-run        # preview saja
./uninstall.sh --force          # skip konfirmasi
./uninstall.sh --prefix ~/custom
```

## Restore

```bash
./restore.sh                          # interactive, pilih backup
./restore.sh 20240720-120000          # restore specific timestamp
./restore.sh --prefix ~/custom        # custom prefix
```

## Keybindings

| Key | Action |
|-----|--------|
| `SUPER + Space` | Rofi app launcher |
| `SUPER + Shift + Space` | Rofi window switcher |
| `SUPER + Shift + E` | Wlogout power menu |
| `SUPER + Return` | Kitty terminal |
| `SUPER + Q` | Close window |
| `SUPER + 1-0` | Switch workspace |
| `SUPER + Shift + 1-0` | Move window to workspace |

## Modular Structure

```
~/.config/
├── hypr/
│   ├── hyprland.conf                  → symlink ke controller/
│   ├── hyprpaper.conf                 → symlink ke wallpaper/controller/
│   ├── model/palette.model.conf
│   ├── service/decoration.service.conf
│   ├── service/animation.service.conf
│   ├── service/layout.service.conf
│   ├── controller/hyprland.controller.conf
│   ├── controller/monitor.controller.conf
│   ├── controller/input.controller.conf
│   ├── controller/env.controller.conf
│   ├── controller/bind.controller.conf
│   └── controller/autostart.controller.conf
├── waybar/
│   ├── config.jsonc                   → symlink ke controller/
│   ├── style.css
│   ├── model/colors.model.css         → symlink ke shared palette
│   ├── service/left.service.jsonc
│   ├── service/center.service.jsonc
│   └── service/right.service.jsonc
├── rofi/
│   ├── config.rasi                    → symlink ke controller/
│   └── ui/
├── kitty/
│   ├── kitty.conf                     → symlink ke controller/
│   ├── model/palette.model.conf
│   └── ui/cursor.ui.conf
├── swaync/
│   ├── config.json                    → symlink ke controller/
│   ├── model/colors.model.css         → symlink ke shared palette
│   └── ui/
├── wlogout/
│   ├── layout                         → symlink ke controller/
│   ├── model/colors.model.css         → symlink ke shared palette
│   └── ui/
└── hypr/hyprpaper.d/
    ├── default.png
```

Entry point symlinks memastikan tools menemukan config mereka di path yang benar (`hyprland.conf`, `config.jsonc`, dll), sementara file asli tetap terorganisir dalam struktur `model/` → `service/` → `controller/` → `ui/`.

## Shared Palette

Semua warna Catppuccin Mocha didefinisikan sekali di `core/model/catppuccin-mocha.css`. Waybar, SwayNC, dan Wlogout menggunakan symlink ke file ini — satu sumber, tidak ada duplikasi.

## Testing

```bash
bash test/integration_test.sh     # 115 tests
bash test/unit_test.sh            # 29 tests
```

