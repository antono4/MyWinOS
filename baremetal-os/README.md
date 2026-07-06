# 🖥️ Bare-metal OS - OS dari Nol

## Deskripsi
Proyek ini membuat sistem operasi sederhana dari awal tanpa menggunakan kernel Linux.
Sistem operasi ini disebut **"NanoOS"** - OS minimal untuk pembelajaran.

## Arsitektur

```
в”Ңв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”җ
в”Ӯ           NanoOS Architecture            в”Ӯ
в”ңв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Ө
в”Ӯ                                         в”Ӯ
в”Ӯ   в”Ңв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”җ   в”Ӯ
в”Ӯ   в”Ӯ      User Space                 в”Ӯ   в”Ӯ
в”Ӯ   в”Ӯ  в”Ңв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”җ в”Ңв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”җ  в”Ӯ   в”Ӯ
в”Ӯ   в”Ӯ  в”Ӯ   Shell   в”Ӯ в”Ӯ   Programs  в”Ӯ  в”Ӯ   в”Ӯ
в”Ӯ   в”Ӯ  в””в”Җв”Җв”Җв”Җв”Җв”¬в”Җв”Җв”Җв”Җв”Җв”ҳ в””в”Җв”Җв”Җв”Җв”Җв”Җв”¬в”Җв”Җв”Җв”Җв”Җв”Җв”ҳ  в”Ӯ   в”Ӯ
в”Ӯ   в”Ӯ        в””в”Җв”Җв”Җв”Җв”Җв”Җв”¬в”Җв”Җв”Җв”Җв”Җв”Җв”Җв”ҳ         в”Ӯ   в”Ӯ
в”Ӯ   в”Ӯ         в”Ңв”Җв”Җв”Җв”Җв–јв”Җв”Җв”Җв”Җв”җ             в”Ӯ   в”Ӯ
в”Ӯ   в”Ӯ         в”Ӯ   libc  в”Ӯ             в”Ӯ   в”Ӯ
в”Ӯ   в”Ӯ         в””в”Җв”Җв”Җв”Җв”¬в”Җв”Җв”Җв”Җв”ҳ             в”Ӯ   в”Ӯ
в”Ӯ   в””в”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”јв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”ҳ   в”Ӯ
в”Ӯ                  в”Ӯ                       в”Ӯ
в”Ӯ   в”Ңв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв–јв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”җ   в”Ӯ
в”Ӯ   в”Ӯ      Kernel Space                в”Ӯ   в”Ӯ
в”Ӯ   в”Ӯ  в”Ңв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”җ в”Ңв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”җ  в”Ӯ   в”Ӯ
в”Ӯ   в”Ӯ  в”Ӯ   VFS    в”Ӯ в”Ӯ  Process Mgr  в”Ӯ  в”Ӯ   в”Ӯ
в”Ӯ   в”Ӯ  в”ңв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Ө в”ңв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Ө  в”Ӯ   в”Ӯ
в”Ӯ   в”Ӯ  в”Ӯ   MMU    в”Ӯ в”Ӯ   Device Drv  в”Ӯ  в”Ӯ   в”Ӯ
в”Ӯ   в”Ӯ  в”ңв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Ө в”ңв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Ө  в”Ӯ   в”Ӯ
в”Ӯ   в”Ӯ  в”Ӯ   IPC    в”Ӯ в”Ӯ   File System  в”Ӯ  в”Ӯ   в”Ӯ
в”Ӯ   в”Ӯ  в””в”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”ҳ в””в”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”ҳ  в”Ӯ   в”Ӯ
в”Ӯ   в””в”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”ҳ   в”Ӯ
в”Ӯ                  в”Ӯ                       в”Ӯ
в”Ӯ   в”Ңв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв–јв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”җ   в”Ӯ
в”Ӯ   в”Ӯ      Hardware (x86/ARM)          в”Ӯ   в”Ӯ
в”Ӯ   в””в”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”ҳ   в”Ӯ
в””в”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”Җв”ҳ
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
в”ңв”Җв”Җ bootloader/
в”Ӯ   в”ңв”Җв”Җ stage1.S          # Stage 1 bootloader
в”Ӯ   в”ңв”Җв”Җ stage2.S          # Stage 2 bootloader
в”Ӯ   в””в”Җв”Җ linker.ld         # Linker script
в”ңв”Җв”Җ kernel/
в”Ӯ   в”ңв”Җв”Җ main.c            # Kernel entry point
в”Ӯ   в”ңв”Җв”Җ idt.c             # Interrupt Descriptor Table
в”Ӯ   в”ңв”Җв”Җ gdt.c             # Global Descriptor Table
в”Ӯ   в”ңв”Җв”Җ memory.c          # Memory management
в”Ӯ   в”ңв”Җв”Җ paging.c          # Paging implementation
в”Ӯ   в”ңв”Җв”Җ vfs.c             # Virtual File System
в”Ӯ   в”ңв”Җв”Җ syscall.c         # System calls
в”Ӯ   в””в”Җв”Җ devices/
в”Ӯ       в”ңв”Җв”Җ keyboard.c    # Keyboard driver
в”Ӯ       в””в”Җв”Җ timer.c       # Timer driver
в”ңв”Җв”Җ libc/
в”Ӯ   в”ңв”Җв”Җ stdio.c           # Standard I/O
в”Ӯ   в”ңв”Җв”Җ string.c          # String operations
в”Ӯ   в””в”Җв”Җ stdlib.c          # Standard library
в”ңв”Җв”Җ shell/
в”Ӯ   в””в”Җв”Җ shell.c           # Interactive shell
в”ңв”Җв”Җ programs/
в”Ӯ   в”ңв”Җв”Җ hello.c           # Sample program
в”Ӯ   в”ңв”Җв”Җ echo.c            # Echo program
в”Ӯ   в””в”Җв”Җ calculator.c      # Simple calculator
в”ңв”Җв”Җ iso/
в”Ӯ   в””в”Җв”Җ Makefile          # Build ISO image
в””в”Җв”Җ README.md
```

## Cara Build & Run

### Prasyarat
```bash
# Install toolchain
sudo apt update
sudo apt install build-essential binutils gcc g++ make grub-common xorriso qemu-system-x86
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

## Screenshots
Boot screen dan shell interaktif akan muncul setelah successful build.

## Pengembangan Lebih Lanjut
- Tambahkan driver untuk hardware lain (VGA, floppy, dll)
- Implementasi multitasking
- Tambahkan networking stack
- Port ke arsitektur ARM
- Tambahkan filesystem lain (ext2, NTFS)

## Lisensi
MIT License
