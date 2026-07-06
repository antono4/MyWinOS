# 🖥️ Windows 10 Theme untuk XFCE

## Deskripsi
Theme ini mengubah tampilan XFCE agar mirip dengan Windows 10, memberikan pengalaman desktop yang familiar bagi pengguna Windows.

## Isi Package
```
windows-10-theme/
├── xfwm4/              # Window manager theme
├── gtk-2.0/            # GTK2 theme
├── gtk-3.0/            # GTK3 theme
├── metacity-1/         # Metacity theme
├── index.theme        # Theme info
└── README.md          # This file
```

## Warna Dominan
| Warna | Hex Code | Penggunaan |
|-------|----------|------------|
| Primary | #0078D4 | Windows Blue |
| Dark | #1A1A1A | Dark background |
| Light | #F3F3F3 | Light elements |
| Accent | #00A4EF | Accent highlights |

## Fitur
- ✅ Window manager theme (xfwm4)
- ✅ GTK2 & GTK3 theming
- ✅ Metacity window decorations
- ✅ Taskbar-like panel styling
- ✅ Start menu button styling

## Instalasi

### Cara 1: Folder Themes
```bash
# Clone atau copy folder ke direktori themes
git clone https://github.com/yourusername/MyWinOS.git
cd MyWinOS/themes/windows-10-theme

# Copy ke folder themes sistem
cp -r windows-10-theme ~/.themes/

# Atau untuk semua user (system-wide)
sudo cp -r windows-10-theme /usr/share/themes/
```

### Cara 2: Via Command Line
```bash
# Install script jika tersedia
cd ../themes
chmod +x install-theme.sh
./install-theme.sh
```

### Apply Theme
1. Buka **XFCE Settings** → **Appearance**
2. Pilih **Windows 10** dari daftar theme
3. Buka **Window Manager** → pilih **Windows 10**
4. Sesuaikan panel dengan theme Windows 10

## Konfigurasi Tambahan

### Panel XFCE
Untuk hasil terbaik, gunakan konfigurasi panel:
```bash
chmod +x configure-panel.sh
./configure-panel.sh
```

### Icon Theme
Disarankan menggunakan icon theme yang sesuai:
- Windows 10 icons
- Fluent icons
- WhiteSur icons

## Kompatibilitas
| Distro | Versi Minimum |
|--------|----------------|
| Xubuntu | 20.04+ |
| Linux Mint XFCE | 20+ |
| Manjaro XFCE | 21+ |
| Fedora XFCE | 34+ |
| Arch Linux XFCE | Latest |

## Lisensi
MIT License
