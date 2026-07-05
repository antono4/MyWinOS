# Panduan Instalasi MyZorinOS

## Persyaratan Sistem

### Minimum
- Prosesor: Dual-core 1.5 GHz
- RAM: 2 GB
- Penyimpanan: 25 GB
- Graphics: Intel HD 2000 / AMD Radeon HD / Nvidia GeForce 6000 series

### Rekomendasi
- Prosesor: Quad-core 2.0 GHz atau lebih
- RAM: 4 GB atau lebih
- Penyimpanan: 50 GB atau lebih
- Graphics: Dedicated GPU (Nvidia, AMD, atau Intel integrated modern)

## Metode Instalasi

### Metode 1: Build dari Source

#### 1. Clone Repository

```bash
git clone https://github.com/yourusername/MyZorinOS.git
cd MyZorinOS/MyZorinOS
```

#### 2. Install Dependencies

```bash
# Untuk Ubuntu/Debian
sudo ./scripts/install/install-deps.sh

# Untuk Fedora
sudo dnf install @development-tools cmake gtk3-devel glib2-devel python3

# Untuk Arch Linux
sudo pacman -S base-devel cmake gtk3 python
```

#### 3. Build dan Install

```bash
sudo ./scripts/build/build-os.sh
```

#### 4. Konfigurasi

```bash
# Apply tema
./appearance/themes/install.sh

# Konfigurasi panel
./desktop-environment/panels/configure.sh
```

### Metode 2: Build ISO

#### 1. Persiapan

```bash
sudo apt-get install live-build squashfs-tools xorriso
```

#### 2. Build ISO

```bash
sudo ./scripts/build/build-iso.sh
```

ISO akan tersedia di `build/myzorinos-{version}.iso`

## Konfigurasi Pasca-Instalasi

### 1. Mengubah Layout Desktop

```bash
# Via terminal
/opt/myzorinos/bin/desktop-manager --set-layout windows
# Atau
/opt/myzorinos/bin/desktop-manager --set-layout macos
# Atau
/opt/myzorinos/bin/desktop-manager --set-layout linux
```

Atau melalui GUI:
1. Buka **Zorin Appearance**
2. Pilih tab **Layout**
3. Pilih layout yang diinginkan
4. Klik **Apply**

### 2. Mengubah Tema

```bash
/opt/myzorinos/bin/desktop-manager --list-themes
/opt/myzorinos/bin/desktop-manager --set-theme "MyZorinOS Dark"
```

Atau melalui GUI:
1. Buka **Zorin Appearance**
2. Pilih tab **Look**
3. Pilih tema, icon, dan cursor

### 3. Mengubah Wallpaper

```bash
/opt/myzorinos/bin/desktop-manager --list-wallpapers
/opt/myzorinos/bin/desktop-manager --set-wallpaper "/path/to/wallpaper.jpg"
```

### 4. Konfigurasi Panel

```bash
# Mengubah posisi panel
/opt/myzorinos/bin/panel-manager --set-position top

# Mengubah tinggi panel
/opt/myzorinos/bin/panel-manager --set-height 48

# Toggle autohide
/opt/myzorinos/bin/panel-manager --toggle-autohide
```

## Troubleshooting

### Panel tidak muncul

```bash
# Restart panel
xfce4-panel --restart

# Atau
pkill xfce4-panel && xfce4-panel &
```

### Tema tidak diterapkan

```bash
# Reset GTK settings
gtk-update-icon-cache -f /usr/share/icons/MyZorinOS
update-desktop-database ~/.local/share/applications
```

### Layout tidak berubah

```bash
# Reload desktop configuration
xfce4-panel --restart
xfsettingsd --restart
```

## Uninstall

```bash
sudo rm -rf /opt/myzorinos
rm -rf ~/.config/myzorinos
rm -f ~/.config/autostart/myzorinos-*.desktop
```

## Dukungan

Jika mengalami masalah:
1. Cek dokumentasi di `docs/`
2. Buat issue di GitHub
3. Hubungi komunitas