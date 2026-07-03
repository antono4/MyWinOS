# 🪟 Panduan Lengkap: Custom Windows-Like OS

## Apa yang Akan Kita Buat?
OS ringan berbasis Linux dengan tampilan seperti Windows 10/11, menggunakan XFCE desktop environment.

**Spesifikasi Target:**
- RAM Minimal: 1GB (disarankan 2GB)
- Disk: 20GB
- Bisa jalan di PC tua (10-15 tahun)

---

## 📋 Daftar Lengkap Bahan

### Yang Dibutuhkan:

#### A. Software:
1. **Ubuntu Server 22.04 LTS** (atau Debian 12) - Download gratis
   - https://ubuntu.com/download/server
   - Size: ~1GB

2. **VirtualBox** (untuk testing) - Download gratis
   - https://www.virtualbox.org/wiki/Downloads

3. **Rufus** (untuk buat USB bootable) - Download gratis
   - https://rufus.ie/id/

4. **Ventoy** (alternatif USB bootable) - Download gratis
   - https://www.ventoy.net/

#### B. Hardware (jika install langsung):
- USB Flashdisk minimal 8GB
- PC/Laptop target

---

## 🚀 TAHAP 1: Persiapan Base System

### Opsi A: Install di VirtualBox (untuk testing)

```
1. Install VirtualBox
2. Buat VM baru:
   - Name: MyWinOS
   - Type: Linux
   - Version: Ubuntu (64-bit)
   - RAM: 2048 MB (2GB)
   - Hard Disk: 25 GB (VDI, Dynamically allocated)
   - CPU: 2 cores
```

### Opsi B: Install di Komputer Real

```
1. Buat USB Bootable:
   - Format USB dengan Rufus
   - Pilih file ISO Ubuntu Server
   - Partition scheme: GPT
   - Target system: UEFI (atau BIOS Legacy)
```

---

## 🔧 TAHAP 2: Install Ubuntu Server Minimal

### Langkah Install:

```
1. Boot dari USB/ISO
2. Pilih "Install Ubuntu Server"
3. Language: English (atau Indonesian)
4. Network: DHCP (otomatis)
5. Proxy: Kosongkan
6. Mirror: Default
7. Storage: Use entire disk (untuk single OS)
   - ATAU "Custom" untuk dual boot
8. Profile Setup:
   - Your name: mywinos
   - Your server's name: mywinos
   - Pick a username: mywinos
   - Password: (buat strong password)
9. Install OpenSSH server: YES
10. Snap packages: NO (untuk lebih ringan)
11. Reboot
```

---

## 💻 TAHAP 3: Install Desktop Environment (XFCE)

Login ke sistem, lalu jalankan:

```bash
# Update sistem
sudo apt update && sudo apt upgrade -y

# Install XFCE Desktop (ringan, mirip Windows)
sudo apt install -y xfce4 xfce4-goodies

# Install Display Manager (LightDM)
sudo apt install -y lightdm lightdm-gtk-greeter

# Install tambahan
sudo apt install -y --no-install-recommends \
    gtk2-engines-murrine \
    gtk2-engines-pixbuf \
    gnome-icon-theme \
    fonts-notify-osd \
    xfwm4-themes

# Set XFCE sebagai default
sudo systemctl set-default graphical.target

# Reboot
sudo reboot
```

---

## 🎨 TAHAP 4: Pasang Tema Windows 10/11

### Download dan Install Theme:

```bash
# Buat folder themes
mkdir -p ~/.themes ~/.icons ~/.backgrounds

# Install dependencies
sudo apt install -y git curl wget

# Download Windows 10/11 theme (McOS-Transformation)
cd /tmp
git clone https://github.com/B00merang-Project/Windows-10-Transformation.git
git clone https://github.com/B00merang-Project/Windows-11-Transformation.git

# Copy themes
cp -r Windows-10-Transformation/* ~/.themes/
cp -r Windows-11-Transformation/* ~/.themes/

# Download Icons
git clone https://github.com/kee-g器的/Windows-10-Icons.git
cp -r Windows-10-Icons/* ~/.icons/

# Download Wallpapers
mkdir -p ~/Pictures/Wallpapers
wget -O ~/Pictures/Wallpapers/win11-1.jpg "https://images.unsplash.com/photo-1620121692029-d088224ddc74?w=1920"
wget -O ~/Pictures/Wallpapers/win11-2.jpg "https://images.unsplash.com/photo-1593640408182-31c228a08b7c?w=1920"
```

### Konfigurasi Tema via CLI:

```bash
# Set theme menggunakan xfconf-query (bagian dari XFCE)
xfconf-query -c xfwm4 -p /general/theme -s "Windows-10-Dark"
xfconf-query -c xfwm4 -p /general/title_font -s "Sans Bold 9"

# Set icon theme
xfconf-query -c xsettings -p /Net/IconThemeName -s "Windows-10"

# Set GTK theme
xfconf-query -c xsettings -p /Net/ThemeName -s "Windows-10-Dark"

# Set wallpaper
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s "$HOME/Pictures/Wallpapers/win11-1.jpg"
```

---

## 📦 TAHAP 5: Install Aplikasi Ringan

```bash
# Web Browser - Firefox (ringan) atau Chromium
sudo apt install -y firefox

# Office Suite - LibreOffice (compatible dengan MS Office)
sudo apt install -y libreoffice-calc libreoffice-writer libreoffice-impress

# Media Player
sudo apt install -y vlc audacious

# Image Viewer
sudo apt install -y viewnior gwenview

# File Manager tambahan
sudo apt install -y thunar-archive-plugin

# System Tools
sudo apt install -y gnome-disk-utility baobab gparted

# Screenshot tool
sudo apt install -y gnome-screenshot scrot

# Terminal (jika belum ada)
sudo apt install -y xfce4-terminal

# Text Editor
sudo apt install -y mousepad

# Archive Manager
sudo apt install -y file-roller

# Software Center
sudo apt install -y gnome-software
```

---

## ⚡ TAHAP 6: Optimalisasi Performa

### Disable Animasi (untuk PC lama):
```bash
# Disable all animations
xfconf-query -c xfwm4 -p /general/use_compositing -s false
xfconf-query -c xsettings -p /Net/EnableAnimations -s false
```

### Optimize Swap:
```bash
# Edit sysctl.conf
sudo nano /etc/sysctl.conf

# Tambahkan di akhir file:
vm.swappiness=10
vm.vfs_cache_pressure=50
```

### Disable Unnecessary Services:
```bash
# List services
systemctl list-units --type=service

# Disable kalau perlu (contoh)
sudo systemctl disable bluetooth  # kalau tidak pakai bluetooth
sudo systemctl mask gpu-manager  # kalau tidak ada GPU diskrit
```

---

## 🖥️ TAHAP 7: Konfigurasi Tampilan Windows

### Buat Panel Seperti Windows 10:

```bash
# Klik kanan pada panel → Panel → Panel Preferences

# Settings:
- Mode: Horizontal
- Length: 100%
- Position: Top
- Size: 32px

# Items (add):
- [x] Application Menu → Icon: Windows logo
- [x] Launcher → Add favorite apps
- [x] Separator
- [x] Window Buttons
- [x] Separator
- [x] Notification Area
- [x] Separator
- [x] Clock
- [x] Action Button
```

### Konfigurasi Whisker Menu (Start Menu):
```bash
# Install whisker menu (biasanya sudah include)
# Klik kanan panel → Add New Items → Whisker Menu

# Konfigurasi:
- Icon: Windows logo
- Command: xfce4-popup-whiskermenu
```

---

## 🔨 TAHAP 8: Buat Bootable USB

### Menggunakan Rufus:

```
1. Buka Rufus
2. Device: Pilih USB Flashdisk (8GB+)
3. Boot selection: Pilih file ISO MyWinOS (nanti kita buat)
4. Partition scheme: GPT
5. Target system: UEFI (atau BIOS + UEFI)
6. File system: FAT32
7. Click "START"
```

### Menggunakan Ventoy (lebih mudah):

```
1. Install Ventoy di USB
2. Copy file ISO ke USB
3. Boot → Pilih ISO dari menu
```

---

## 📀 TAHAP 9: Build Custom ISO

### Install Remastersys (untuk backup/clone):

```bash
# Tambah repository
sudo add-apt-repository ppa:mutarsey/ubuntu
sudo apt update

# Install
sudo apt install -y remastersys

# Atau gunakan script custom kita (lihat BUILD-ISO.sh)
```

### Atau Gunakan Script Custom:

```bash
# Jalankan script build
chmod +x BUILD-ISO.sh
sudo ./BUILD-ISO.sh
```

---

## ✅ Checklist Sebelum Selesai

- [ ] Ubuntu Server terinstall
- [ ] XFCE Desktop terinstall
- [ ] Tema Windows 10/11 aktif
- [ ] Aplikasi dasar terinstall
- [ ] Performa dioptimasi
- [ ] Bootable USB/ISO dibuat
- [ ] Testing di VM berhasil
- [ ] Testing di hardware berhasil

---

## 🎯 Tips Tambahan

### Untuk PC Sangat Lama (RAM 512MB):
```bash
# Install LXDE sebagai alternatif lebih ringan
sudo apt install -y lxde
```

### Untuk Gaming Ringan:
```bash
# Install Steam dan Wine
sudo apt install -y steam-installer wine
```

### Untuk Dual Boot Windows:
```bash
# Install os-prober
sudo apt install -y os-prober

# Update GRUB
sudo update-grub
```

---

## 📞 Troubleshooting

### Q: Black screen setelah reboot?
```
- Tekan Ctrl+Alt+F2 untuk masuk CLI
- Cek .xorg.log untuk error
- Jalankan: startx
```

### Q: Tema tidak 적용?
```
- Pastikan file theme di ~/.themes/
- Reset XFCE: xfconf-query --reset -f
```

### Q: Boot lambat?
```
- Disable splash screen di GRUB
- Check disk dengan: fsck
```

---

## 📚 Referensi

- XFCE Docs: https://docs.xfce.org/
- Ubuntu Docs: https://docs.ubuntu.com/
- Linux Mint Themes: https://linuxmint.com/download_lmde.php

---

**Happy Building! 🎉**

*Dibuat dengan ❤️ untuk Indonesia*
