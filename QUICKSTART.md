# 🚀 MyWinOS Quick Start Guide

## Cara Tercepat Membuat OS Windows-Like Anda Sendiri!

---

## ⚡ Opsi 1: Demo & Testing (30 Menit)

### Yang Dibutuhkan:
- VirtualBox (gratis): https://www.virtualbox.org/
- Ubuntu Server 22.04 ISO: https://ubuntu.com/download/server

### Langkah:

```bash
# 1. Install VirtualBox dan buat VM baru
#    - RAM: 2GB
#    - Disk: 25GB
#    - OS: Ubuntu (64-bit)

# 2. Install Ubuntu Server
#    Ikuti wizard instalasi Ubuntu

# 3. Setelah login, jalankan:
sudo apt update && sudo apt upgrade -y
sudo apt install -y xfce4 xfce4-goodies lightdm
sudo systemctl set-default graphical.target
sudo reboot
```

```bash
# 4. Login ke desktop XFCE
#    Apply Windows theme:

# Download theme
cd ~
git clone https://github.com/B00merang-Project/Windows-10-Transformation.git
cp -r Windows-10-Transformation ~/.themes/

# Apply theme via GUI:
# Settings → Appearance → Style → Windows-10
# Settings → Window Manager → Style → Windows-10
```

---

## 💾 Opsi 2: Build Custom ISO (60-90 Menit)

### Yang Dibutuhkan:
- Ubuntu/Debian system (untuk build)
- 20GB free disk space
- Koneksi internet stabil

### Langkah:

```bash
# 1. Install dependensi
sudo apt update
sudo apt install -y \
    debootstrap \
    squashfs-tools \
    xorriso \
    qemu-utils \
    git

# 2. Clone/download project
git clone https://github.com/yourusername/mywinos.git
cd mywinos

# 3. Jalankan build script
chmod +x BUILD-ISO.sh
sudo ./BUILD-ISO.sh

# 4. Pilih "1" untuk Full Build
# 5. Tunggu 30-60 menit
# 6. ISO ada di folder output/
```

---

## 🔧 Opsi 3: Custom Theme Saja (15 Menit)

Jika sudah punya Linux dengan XFCE:

```bash
# Download dan apply theme
cd ~
git clone https://github.com/B00merang-Project/Windows-10-Transformation.git
git clone https://github.com/B00merang-Project/Windows-11-Transformation.git

# Install
cp -r Windows-* ~/.themes/
cp -r Windows-* ~/.themes/

# Apply via command line
xfconf-query -c xfwm4 -p /general/theme -s "Windows-10-Dark"
xfconf-query -c xsettings -p /Net/ThemeName -s "Windows-10-Dark"
```

---

## 📋 Checklist Sebelum Memulai

- [ ] VirtualBox terinstall (untuk testing)
- [ ] Download Ubuntu Server ISO
- [ ] USB 8GB ready (untuk install langsung)
- [ ] Koneksi internet stabil
- [ ] Backup data penting (jika install langsung)

---

## 🎯 Hasil Akhir

Setelah selesai, Anda akan memiliki:

```
✅ OS dengan tampilan Windows 10/11
✅ RAM usage: ~500MB (idle)
✅ Boot time: ~15-20 detik
✅ Aplikasi dasar terinstall
✅ Gratis dan open source
```

---

## 📞 Butuh Bantuan?

1. **Masalah Install?** → Baca PANDUAN-INSTALL.md
2. **Masalah Theme?** → Baca themes/README.md
3. **Error saat build?** → Cek dependensi dan disk space

---

## 💡 Tips Pro

### Untuk PC Sangat Lama (RAM 512MB):
Gunakan Lubuntu (LXQt) sebagai pengganti:
```bash
sudo apt install -y lubuntu-desktop
```

### Untuk Gaming:
Tambahkan Wine + Steam:
```bash
sudo apt install -y wine steam-installer
```

### Untuk Kantor:
Tambahkan Microsoft Fonts:
```bash
sudo apt install -y ttf-mscorefonts-installer
```

---

**Selamat mencoba! 🎉**
