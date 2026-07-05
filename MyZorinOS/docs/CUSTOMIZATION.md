# Panduan Kustomisasi MyZorinOS

## Daftar Isi
1. [Mengubah Layout Desktop](#mengubah-layout-desktop)
2. [Kustomisasi Tema](#kustomisasi-tema)
3. [Mengubah Wallpaper](#mengubah-wallpaper)
4. [Konfigurasi Panel](#konfigurasi-panel)
5. [Konfigurasi Dock](#konfigurasi-dock)
6. [Pengaturan Font](#pengaturan-font)
7. [Membuat Tema Kustom](#membuat-tema-kustom)

---

## Mengubah Layout Desktop

MyZorinOS mendukung 3 layout desktop:

### Layout Windows
Tampilan klasik Windows dengan:
- Taskbar di bagian bawah
- Tombol Start di kiri
- Quick launch di atas taskbar

### Layout macOS
Tampilan macOS dengan:
- Menu bar di bagian atas
- Dock di bagian bawah dengan magnification
- Aplikasi minimizes ke dock

### Layout Linux
Tampilan tradisional Linux dengan:
- Panel di bagian atas
- Workspace switcher
- Window list di panel

### Cara Mengubah

**Via Terminal:**
```bash
/opt/myzorinos/bin/desktop-manager --set-layout windows
```

**Via GUI:**
1. Buka **Zorin Appearance** dari Applications Menu
2. Pilih tab **Layout**
3. Klik layout yang diinginkan
4. Klik **Apply**

---

## Kustomisasi Tema

### Tema Bawaan

1. **MyZorinOS Dark** - Tema gelap modern dengan aksen ungu
2. **MyZorinOS Light** - Tema terang bersih
3. **MyZorinOS Gruvbox** - Tema retro dengan warna hangat

### Mengubah Tema

**Via Terminal:**
```bash
# Daftar tema
/opt/myzorinos/bin/desktop-manager --list-themes

# Mengubah tema
/opt/myzorinos/bin/desktop-manager --set-theme "MyZorinOS Dark"
```

**Via GUI:**
1. Buka **Zorin Appearance**
2. Pilih tab **Look**
3. Pilih tema dari gallery
4. Klik **Apply**

### Mengubah Icon Theme

**Via GUI:**
1. Buka **Zorin Appearance**
2. Pilih tab **Look**
3. Scroll ke bagian **Icons**
4. Pilih icon theme
5. Klik **Apply**

---

## Mengubah Wallpaper

### Wallpaper Bawaan

Beberapa wallpaper default tersedia di:
`/opt/myzorinos/share/myzorinos/wallpapers/`

### Mengubah Wallpaper

**Via Terminal:**
```bash
/opt/myzorinos/bin/desktop-manager --list-wallpapers
/opt/myzorinos/bin/desktop-manager --set-wallpaper "/path/to/wallpaper.jpg"
```

**Via GUI:**
1. Klik kanan pada desktop
2. Pilih **Change Desktop Background**
3. Pilih wallpaper atau klik **+** untuk menambah

### Mengatur Slide Show

1. Buka **Zorin Appearance**
2. Pilih tab **Background**
3. Aktifkan **Slideshow**
4. Pilih folder wallpaper
5. Atur interval pergantian

---

## Konfigurasi Panel

Panel adalah bar yang berisi ikon aplikasi, jam, dan sistem tray.

### Mengubah Posisi Panel

```bash
/opt/myzorinos/bin/panel-manager --set-position top
```

Posisi yang valid: `top`, `bottom`, `left`, `right`

### Mengubah Tinggi Panel

```bash
/opt/myzorinos/bin/panel-manager --set-height 48
```

Tinggi minimum: 20px, maksimum: 100px

### Toggle Autohide

```bash
/opt/myzorinos/bin/panel-manager --toggle-autohide
```

### Konfigurasi Manual

Edit file konfigurasi:
```bash
nano ~/.config/myzorinos/panels/panel.json
```

Contoh konfigurasi:
```json
{
    "position": "bottom",
    "height": 40,
    "autohide": false,
    "elements": {
        "start_button": {"visible": true},
        "launcher": {"visible": true, "items": ["file-manager", "terminal"]},
        "taskbar": {"visible": true},
        "system_tray": {"visible": true}
    }
}
```

---

## Konfigurasi Dock

Dock hanya tersedia di layout macOS.

### Mengatur Posisi

```json
{
    "dock": {
        "position": "bottom",  // atau "left", "right"
        "magnification": true,
        "autohide": true
    }
}
```

### Mengatur Ukuran Ikon

```json
{
    "dock": {
        "size": {
            "icon_size": 48,
            "magnified_size": 64
        }
    }
}
```

### Menambah/Menghapus Aplikasi

Edit file `~/.config/myzorinos/dock.conf`:
```json
{
    "items": [
        {"id": "file-manager", "icon": "folder", "type": "app"},
        {"id": "terminal", "icon": "terminal", "type": "app"},
        {"type": "separator"},
        {"id": "settings", "icon": "settings", "type": "app"}
    ]
}
```

---

## Pengaturan Font

### Mengubah Font Sistem

**Via GUI:**
1. Buka **Zorin Appearance**
2. Pilih tab **Fonts**
3. Pilih font untuk:
   - Interface font
   - Document font
   - Monospace font (terminal)
4. Atur ukuran dan rendering
5. Klik **Apply**

### Font yang Direkomendasikan

- **Interface:** Ubuntu, Cantarell, Noto Sans
- **Document:** Noto Serif, Liberation Serif
- **Monospace:** Ubuntu Mono, JetBrains Mono, Fira Code

### Mengatur Rendering Font

```bash
# Via GNOME Tweaks
gnome-tweaks

# Atau manual
nano ~/.config/fontconfig/fonts.conf
```

---

## Membuat Tema Kustom

### Struktur Tema

```
my-custom-theme/
├── theme.json          # Metadata tema
├── gtk.css             # GTK styles
├── index.theme         # Desktop entry
├── xfwm4/              # Window manager theme
│   └── themerc
├── metacity-1/         # Window decorations
│   └── metacity-theme-1.xml
└── cinnamon/           # Cinnamon specific (optional)
```

### theme.json

```json
{
    "id": "my-custom-theme",
    "name": "My Custom Theme",
    "description": "Tema kustom saya",
    "category": "dark",
    "colors": {
        "accent": "#7c4dff",
        "background": "#1e1e1e",
        "surface": "#2a2a2a",
        "text": "#ffffff",
        "text-secondary": "#b3b3b3"
    }
}
```

### gtk.css

```css
/* Override colors */
@define-color accent_color #7c4dff;
@define-color window_bg_color #1e1e1e;
@define-color sidebar_bg_color #252525;

/* Custom styles */
window {
    border-radius: 8px;
}

button {
    border-radius: 6px;
}
```

### install.sh

```bash
#!/bin/bash
cp -r my-custom-theme ~/.themes/
gtk-update-icon-cache -f ~/.themes/my-custom-theme
```

---

## Tips dan Tricks

### Reset ke Default

```bash
rm -rf ~/.config/myzorinos
/opt/myzorinos/scripts/config/reset-defaults.sh
```

### Backup Konfigurasi

```bash
tar -czvf myzorinos-backup.tar.gz ~/.config/myzorinos
```

### Restore Konfigurasi

```bash
tar -xzvf myzorinos-backup.tar.gz -C ~/
```

### Screenshot Tema

Gunakan工具 seperti `xfce4-screenshooter` atau `spectacle` untuk screenshot desktop dengan tema yang berbeda.