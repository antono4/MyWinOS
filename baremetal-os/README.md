# 🖥️ Bare-metal OS - OS dari Nol

## Deskripsi
Proyek ini membuat sistem operasi sederhana dari awal tanpa menggunakan kernel Linux.
Sistem operasi ini disebut **"NanoOS"** - OS minimal untuk pembelajaran.

## Arsitektur

```
+------------------------------------------------------------------+
|                    NanoOS Architecture                             |
+------------------------------------------------------------------+
|                                                                    |
|  +------------------------------------------------------------+   |
|  |                      User Space                              |   |
|  |  +------------------+      +------------------+             |   |
|  |  |      Shell       |      |    Programs      |             |   |
|  |  +------------------+      +------------------+             |   |
|  |                      |                       |             |   |
|  |                +-----+-----+                           |   |
|  |                |    libc    |                           |   |
|  |                +-------------+                           |   |
|  +------------------------------------------------------------+   |
|                              |                                  |
|  +------------------------------------------------------------+   |
|  |                    Kernel Space                             |   |
|  |  +-------------+     +------------------+                  |   |
|  |  |    VFS      |     |   Process Mgr    |                  |   |
|  |  +------+------+     +--------+---------+                  |   |
|  |  | MMU  |  IPC |     | Device Drv |  FS   |                  |   |
|  |  +------+------+     +------------+-------+                  |   |
|  +------------------------------------------------------------+   |
|                              |                                  |
|  +------------------------------------------------------------+   |
|  |               Hardware (x86/ARM)                            |   |
|  +------------------------------------------------------------+   |
+------------------------------------------------------------------+
```

## Fitur

- ✅ Bootloader sederhana (GRUB multiboot)
- ✅ Kernel 32-bit sederhana
- ✅ Memory Management (paging)
- ✅ Interrupt Handling
- ✅ Basic VFS (Virtual File System)
- ✅ Shell interaktif
- ✅ Timer & Keyboard driver
- ✅ FAT12 filesystem support

## Struktur Direktori

```
baremetal-os/
├── bootloader/
│   ├── stage1.S          # Stage 1 bootloader
│   ├── stage2.S          # Stage 2 bootloader
│   └── linker.ld         # Linker script
├── kernel/
│   ├── main.c            # Kernel entry point
│   ├── idt.c             # Interrupt Descriptor Table
│   ├── gdt.c             # Global Descriptor Table
│   ├── memory.c          # Memory management
│   ├── paging.c          # Paging implementation
│   ├── vfs.c             # Virtual File System
│   ├── syscall.c         # System calls
│   └── devices/
│       ├── keyboard.c    # Keyboard driver
│       └── timer.c       # Timer driver
├── libc/
│   ├── stdio.c           # Standard I/O
│   ├── string.c          # String operations
│   └── stdlib.c          # Standard library
├── shell/
│   └── shell.c           # Interactive shell
├── programs/
│   ├── hello.c           # Sample program
│   ├── echo.c            # Echo program
│   └── calculator.c      # Simple calculator
└── iso/
    └── Makefile          # Build ISO image
```

## Cara Build & Run

### Prasyarat
```bash
# Install toolchain
sudo apt update
sudo apt install build-essential binutils gcc g++ make nasm grub-common xorriso qemu-system-x86
```

### Build
```bash
cd baremetal-os
make all
```

### Run di QEMU
```bash
make run
```

### Build ISO
```bash
make iso
```

## Pengembangan Lebih Lanjut

- Tambahkan driver untuk hardware lain (VGA, floppy, dll)
- Implementasi multitasking
- Tambahkan networking stack
- Port ke arsitektur ARM
- Tambahkan filesystem lain (ext2, NTFS)

## Lisensi

MIT License
