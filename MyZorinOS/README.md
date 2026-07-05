# MyZorinOS - Custom Linux Distribution Mirip Zorin OS

**MyZorinOS** adalah distribusi Linux kustom yang terinspirasi dari Zorin OS, dirancang untuk memberikan pengalaman desktop yang familiar dan mudah digunakan bagi pengguna Windows dan macOS.

![MyZorinOS Desktop](docs/screenshots/desktop-preview.png)

## ✨ Fitur Utama

### 🎨 Multi-Layout Desktop
MyZorinOS memungkinkan Anda mengubah tampilan desktop menjadi:
- **Layout Windows** - Tampilan klasik Windows dengan taskbar di bawah
- **Layout macOS** - Tampilan macOS dengan dock di samping/bawah
- **Layout Linux** - Tampilan tradisional Linux dengan panel di atas

### 📱 Aplikasi Bawaan
- **Zorin Appearance** - Aplikasi untuk mengkustomisasi tampilan desktop
- **Zorin Settings** - Pengaturan sistem lengkap
- **File Manager** - Manajemen file modern
- **Terminal** - Terminal dengan fitur lengkap
- **Text Editor** - Editor teks ringan
- **Software Center** - Pusat aplikasi dan pembaruan

### 🎮 Gaming Ready
- Support untuk NVIDIA, AMD, dan Intel graphics
- Kompatibel dengan Steam, Lutris, dan platform gaming lainnya
- Dukungan untuk Windows games melalui Wine/Proton

### 🔒 Keamanan & Privasi
- Tidak mengumpulkan data pengguna
- Open source dan dapat diverifikasi
- Update keamanan reguler

## 📋 Kebutuhan Sistem

| Komponen | Minimum | Rekomendasi |
|----------|---------|-------------|
| CPU | Dual-core 1.5 GHz | Quad-core 2.0 GHz |
| RAM | 2 GB | 4 GB |
| Storage | 25 GB | 50 GB |
| Graphics | Intel HD 2000 | Dedicated GPU |

## 🚀 Cara Install

### Metode 1: Build dari Source

```bash
# Clone repository
git clone https://github.com/yourusername/MyZorinOS.git
cd MyZorinOS

# Install dependencies
sudo ./scripts/install/deps.sh

# Build OS
sudo ./scripts/build/build-os.sh

# Install
sudo ./scripts/install/install-os.sh
```

### Metode 2: Build ISO

```bash
# Generate ISO
sudo ./scripts/build/build-iso.sh
```

## 📂 Struktur Proyek

```
MyZorinOS/
├── desktop-environment/     # Desktop environment components
│   ├── panels/             # Panel configurations
│   ├── dock/               # Dock implementation
│   ├── widgets/            # Desktop widgets
│   └── compositor/         # Window compositor
├── appearance/             # Appearance customization
│   ├── layouts/           # Desktop layouts
│   ├── themes/            # GTK/Qt themes
│   ├── icons/             # Icon themes
│   ├── wallpapers/        # Wallpaper collection
│   └── fonts/             # Font configurations
├── apps/                   # Aplikasi bawaan
│   ├── zorin-appearance/ # Appearance app
│   ├── zorin-settings/    # System settings
│   ├── file-manager/      # File manager
│   ├── terminal/          # Terminal emulator
│   └── software-center/   # Software store
├── scripts/               # Build & install scripts
│   ├── install/           # Installation scripts
│   ├── config/            # Configuration scripts
│   └── build/             # Build scripts
└── packages/              # Package manifest
```

## 🎨 Kustomisasi

### Mengubah Layout Desktop

Buka **Zorin Appearance** → Pilih tab **Layout** → Pilih layout yang diinginkan

### Mengubah Tema

1. Buka **Zorin Appearance**
2. Pilih **Look** tab
3. Pilih theme, icon, dan wallpaper

### Membuat Layout Kustom

Edit file konfigurasi di `~/.config/myzorinos/layouts/`

## 🔧 Konfigurasi

### Konfigurasi Panel

Panel dikonfigurasi melalui JSON di `~/.config/myzorinos/panels/`

### Konfigurasi Theme

Theme system menggunakan GTK3/4 dan Qt5/6

## 📦 Base Distribution

MyZorinOS dibangun di atas:
- **Ubuntu 24.04 LTS** - Base system
- **XFCE 4.18** - Desktop environment
- **GTK 4.10** - UI toolkit
- **Linux 6.8** - Kernel

## 🤝 Kontribusi

Kontribusi sangat diterima! Silakan:

1. Fork repository ini
2. Buat branch baru (`git checkout -b feature/AmazingFeature`)
3. Commit perubahan (`git commit -m 'Add AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buat Pull Request

## 📄 Lisensi

Proyek ini dilisensikan di bawah MIT License - lihat file [LICENSE](../LICENSE) untuk detail.

## 🙏 Kredit

- **Zorin OS** - Inspirasi utama
- **XFCE** - Desktop environment
- **Ubuntu** - Base distribution
- **GNOME** - Komponen UI

## 📚 Dokumentasi

- [Instalasi](docs/INSTALL.md)
- [Kustomisasi](docs/CUSTOMIZATION.md)
- [Pengembangan](docs/DEVELOPMENT.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)

---

Dibuat dengan ❤️ untuk komunitas Linux Indonesia