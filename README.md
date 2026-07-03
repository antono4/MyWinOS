# 🖥️ OS Project - Custom Linux Distribution & Bare-metal OS

Proyek ini berisi dua implementasi untuk membuat sistem operasi:

---

## 📁 Proyek 1: Bare-metal OS (OS dari Nol)
**Lokasi:** `/workspace/project/baremetal-os`

OS sederhana yang dibuat dari awal tanpa menggunakan kernel Linux.

### Fitur:
- ✅ Bootloader (Stage 1 & Stage 2)
- ✅ Kernel 32-bit
- ✅ GDT & IDT (Global/Interrupt Descriptor Tables)
- ✅ Memory Management
- ✅ Virtual File System (VFS)
- ✅ Keyboard & Timer Drivers
- ✅ Shell Interaktif

### Cara Build:
```bash
cd baremetal-os
make
make run    # Run di QEMU
```

### Struktur:
```
baremetal-os/
├── bootloader/    # Stage 1 & 2 bootloader
├── kernel/        # Kernel source
│   └── devices/  # Drivers
├── libc/          # C library
├── shell/         # Shell interaktif
└── Makefile
```

---

## 📁 Proyek 2: Custom Linux Distribution
**Lokasi:** `/workspace/project/custom-linux-distro`

Distro Linux kustom menggunakan metodologi Linux From Scratch (LFS).

### Fitur:
- ✅ GCC 13.2.0 Compiler
- ✅ Glibc 2.38 C Library
- ✅ Linux 6.4 Kernel
- ✅ Bash 5.2 Shell
- ✅ Python 3.11
- ✅ Vim 9.0 Editor
- ✅ GRUB 2.06 Bootloader
- ✅ Systemd Init System

### Cara Build:
```bash
cd custom-linux-distro
chmod +x scripts/*.sh

# Step 1: Persiapan sistem
sudo ./scripts/01-prepare-system.sh

# Step 2: Build temporary system
sudo ./scripts/02-temp-system.sh

# Step 3: Build final system
sudo ./scripts/03-final-system.sh

# Step 4: Konfigurasi
sudo ./scripts/04-config-system.sh

# Step 5: Bootloader
sudo ./scripts/05-bootloader.sh
```

### Struktur:
```
custom-linux-distro/
├── scripts/       # Build scripts
│   ├── 01-prepare-system.sh
│   ├── 02-temp-system.sh
│   ├── 03-final-system.sh
│   ├── 04-config-system.sh
│   └── 05-bootloader.sh
├── packages/      # Package list
├── config/        # Konfigurasi
└── docs/         # Dokumentasi
```

---

## 📊 Perbandingan

| Aspek | Bare-metal OS | Custom Linux Distro |
|-------|--------------|---------------------|
| Kompleksitas | ⭐⭐ (Ringan) | ⭐⭐⭐⭐⭐ (Kompleks) |
| Waktu Build | Menit | Jam |
| Hardware | x86 only | Multi-platform |
| Dependencies | Tidak ada | LFS toolchain |
| Fleksibilitas | Tinggi | Tinggi |
| Cocok untuk | Pembelajaran | Produksi |

---

## 📚 Referensi

- [Linux From Scratch (LFS)](https://www.linuxfromscratch.org/)
- [OSDev Wiki](https://wiki.osdev.org/)
- [Writing a Simple Operating System from Scratch](https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf)

---

## ⚠️ Catatan

1. **Bare-metal OS** - Cocok untuk pembelajaran cara kerja OS
2. **Custom Linux Distro** - Membutuhkan Linux host dengan minimal 30GB storage dan 4GB RAM

---

## 📝 Lisensi

MIT License
