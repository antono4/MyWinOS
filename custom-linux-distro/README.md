# 🐧 Custom Linux Distribution - Linux From Scratch

## Deskripsi
Proyek ini adalah panduan lengkap untuk membangun distribusi Linux kustom Anda sendiri menggunakan metodologi **Linux From Scratch (LFS)**.

## Arsitektur LFS

```
┌─────────────────────────────────────────────────────────────┐
│                    Linux From Scratch                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   Phase 1: System Preparation                                │
│   ┌──────────────────────────────────────────────────────┐   │
│   │ • Partition & Filesystem Creation                   │   │
│   │ • Download Source Packages                          │   │
│   │ • Set Up Build Environment                          │   │
│   │ • Create Directory Structure                        │   │
│   └──────────────────────────────────────────────────────┘   │
│                            │                                 │
│   Phase 2: Temporary System Build                           │
│   ┌──────────────────────────────────────────────────────┐   │
│   │ • Binutils-2.41    - Binary utilities                │   │
│   │ • GCC-13.2.0       - C/C++ Compiler                   │   │
│   │ • Glibc-2.38       - C Library                        │   │
│   │ • Linux API Headers                                 │   │
│   │ • Tcl, Expect, DejaGNU - Test Suite                 │   │
│   │ • GMP, MPFR, MPC - Compiler Dependencies           │   │
│   └──────────────────────────────────────────────────────┘   │
│                            │                                 │
│   Phase 3: Final System Build                                │
│   ┌──────────────────────────────────────────────────────┐   │
│   │ • Coreutils-9.3    - Basic system utilities         │   │
│   │ • Bash-5.2.15       - Shell                          │   │
│   │ • File-5.45        - File type detection            │   │
│   │ • Gawk-5.2.2       - AWK interpreter                │   │
│   │ • GCC-13.2.0       - (Final) Compiler                 │   │
│   │ • Glibc-2.38       - (Final) C Library               │   │
│   │ • Grep-3.11        - Pattern matching                │   │
│   │ • Gzip-1.12        - Compression                    │   │
│   │ • Make-4.4.1       - Build tool                     │   │
│   │ • Man-DB-2.11.3    - Manual pages                   │   │
│   │ • Perl-5.36.1      - Perl interpreter                │   │
│   │ • Python-3.11.4    - Python interpreter             │   │
│   │ • Vim-9.0.1670     - Text editor                    │   │
│   │ • systemd-253      - System & Service Manager       │   │
│   │ • Linux Kernel-6.4 - Operating System Kernel        │   │
│   └──────────────────────────────────────────────────────┘   │
│                            │                                 │
│   Phase 4: System Configuration                              │
│   ┌──────────────────────────────────────────────────────┐   │
│   │ • /etc/passwd        - User database                  │   │
│   │ • /etc/group         - Group database                 │   │
│   │ • /etc/fstab         - Filesystem mount table         │   │
│   │ • /etc/hosts         - Hostname resolution            │   │
│   │ • /etc/sysconfig     - System configuration           │   │
│   │ • Network Setup                                       │   │
│   │ • Systemd Configuration                               │   │
│   └──────────────────────────────────────────────────────┘   │
│                            │                                 │
│   Phase 5: Bootloader & Kernel                              │
│   ┌──────────────────────────────────────────────────────┐   │
│   │ • GRUB2 Installation                                  │   │
│   │ • Kernel Configuration                                │   │
│   │ • Module Compilation                                  │   │
│   └──────────────────────────────────────────────────────┘   │
│                            │                                 │
│   ┌──────────────────────────────────────────────────────┐   │
│   │              🎉 YOUR CUSTOM LINUX DISTRO! 🎉         │   │
│   └──────────────────────────────────────────────────────┘   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Struktur Direktori

```
custom-linux-distro/
├── scripts/
│   ├── 01-prepare-system.sh       # System preparation
│   ├── 02-temp-system.sh          # Build temporary tools
│   ├── 03-final-system.sh         # Build final system
│   ├── 04-config-system.sh        # Configure system
│   ├── 05-bootloader.sh           # Install bootloader
│   └── build-package.sh           # Generic package builder
├── packages/
│   └── list.txt                   # List of all packages
├── config/
│   ├── kernel-config               # Kernel configuration
│   ├── fstab                      # Filesystem table
│   ├── hostname                   # Hostname
│   └── locale.gen                 # Locale settings
├── docs/
│   ├── BUILD.md                   # Detailed build guide
│   └── TROUBLESHOOT.md           # Common issues
└── README.md
```

## Package List

### Temporary System Tools
| Package | Version | Purpose |
|--------|---------|---------|
| Binutils | 2.44 | Binary utilities (ld, as, objcopy) |
| GCC | 14.2.0 | GNU Compiler Collection |
| Glibc | 2.41 | GNU C Library |
| GMP | 6.3.0 | GNU Multiple Precision |
| MPFR | 4.2.1 | Multiple Precision Floating-Point |
| MPC | 1.3.1 | Multiple Precision Complex |
| Linux | 6.12 | API Headers |
| Tcl | 8.6.13 | Tool Command Language |
| Expect | 5.45.4 | Expect automation |
| DejaGNU | 1.6.3 | Testing framework |
| M4 | 1.4.19 | Macro processor |
| Ncurses | 6.5 | Terminal handling |
| Bash | 5.3 | Bourne Again Shell |
| Coreutils | 9.5 | Core utilities |
| Diffutils | 3.11 | File comparison |
| File | 5.45 | File type detection |
| Findutils | 4.10.0 | Finding utilities |
| Gawk | 5.3.1 | AWK interpreter |
| Gettext | 0.22 | Internationalization |
| Grep | 3.11 | Pattern matching |
| Gzip | 1.13 | Compression |
| Make | 4.4.1 | Build tool |
| Patch | 2.7.6 | Apply patches |
| Sed | 4.9 | Stream editor |
| Tar | 1.35 | Archive utility |
| Texinfo | 7.2 | Documentation |
| Xz | 5.6.3 | Compression |

### Final System Packages
| Package | Version | Purpose |
|--------|---------|---------|
| Bzip2 | 1.0.8 | Compression |
| Flex | 2.6.4 | Lexical analyzer |
| Kmod | 33 | Kernel module management |
| Libcap | 2.69 | POSIX capabilities |
| Openssl | 3.3.0 | SSL/TLS library |
| Perl | 5.40.0 | Perl interpreter |
| Python | 3.12.7 | Python interpreter |
| Shadow | 4.13 | Password management |
| Systemd | 256 | System manager |
| Man-DB | 2.13.0 | Manual pages |
| Procps-ng | 4.0.4 | Process utilities |
| Util-linux | 2.40.4 | System utilities |
| Vim | 9.1.0937 | Text editor |
| Linux | 6.12 | Kernel |
| GRUB | 2.12 | Bootloader |

## Cara Build

### Prasyarat
```bash
# Linux host system required
# At least 30GB disk space
# 4GB RAM minimum
# Root access
```

### Langkah 1: Persiapan Sistem
```bash
# Login sebagai root
su -

# Partisi disk (contoh untuk /dev/sdb)
fdisk /dev/sdb
# Buat partisi: /dev/sdb1 (boot), /dev/sdb2 (root), /dev/sdb3 (swap)

# Format filesystem
mkfs.ext4 /dev/sdb2
mkfs.ext4 /dev/sdb1
mkswap /dev/sdb3

# Mount
mount /dev/sdb2 /mnt/lfs
mkdir -pv /mnt/lfs/boot
mount /dev/sdb1 /mnt/lfs/boot
swapon /dev/sdb3
```

### Langkah 2: Download Packages
```bash
mkdir -pv $LFS/sources
# Download semua packages dari mirror
wget --input-list=packages/list.txt -P $LFS/sources
```

### Langkah 3: Build Temporary System
```bash
cd scripts
chmod +x 02-temp-system.sh
./02-temp-system.sh
```

### Langkah 4: Build Final System
```bash
./03-final-system.sh
```

### Langkah 5: Konfigurasi Sistem
```bash
./04-config-system.sh
```

### Langkah 6: Install Bootloader
```bash
./05-bootloader.sh
```

## Hasil
Setelah proses selesai, Anda akan memiliki:
- ✅ Custom Linux Distribution
- ✅ Kernel Linux terbaru
- ✅ Systemd init system
- ✅ Bash shell
- ✅ GCC compiler
- ✅ Python interpreter
- ✅ Vim text editor
- ✅ Semua utilitas dasar

## Customization
- Ganti kernel config untuk hardware Anda
- Tambahkan package favorit
- Custom prompt dan theme
- Pilih desktop environment
- Buat repository package sendiri

## Lisensi
MIT License + LFS Project Guidelines
