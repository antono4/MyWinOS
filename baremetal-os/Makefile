# =============================================================================
# NanoOS Build System
# =============================================================================

# Toolchain
CC = gcc
AS = nasm
LD = ld
OBJCOPY = objcopy

# Flags
CFLAGS = -m32 -nostdinc -fno-pie -ffreestanding -Wall -Wextra
ASFLAGS = -f elf32
LDFLAGS = -T bootloader/linker.ld -nostdlib

# Directories
BOOT_DIR = bootloader
KERNEL_DIR = kernel
LIB_DIR = libc
SHELL_DIR = shell
ISO_DIR = iso

# Output
ISO = NanoOS.iso
KERNEL_BIN = kernel.bin
OS-img = nanoos.img

# Source files
BOOT_SOURCES = $(BOOT_DIR)/stage1.S $(BOOT_DIR)/stage2.S
KERNEL_SOURCES = $(KERNEL_DIR)/main.c $(KERNEL_DIR)/gdt.c $(KERNEL_DIR)/idt.c \
                 $(KERNEL_DIR)/memory.c $(KERNEL_DIR)/vfs.c \
                 $(KERNEL_DIR)/devices/keyboard.c $(KERNEL_DIR)/devices/timer.c
LIB_SOURCES = $(LIB_DIR)/stdio.c $(LIB_DIR)/string.c
SHELL_SOURCES = $(SHELL_DIR)/shell.c

# Objects
BOOT_OBJECTS = $(BOOT_SOURCES:.S=.o)
KERNEL_OBJECTS = $(KERNEL_SOURCES:.c=.o)
LIB_OBJECTS = $(LIB_SOURCES:.c=.o)
SHELL_OBJECTS = $(SHELL_SOURCES:.c=.o)
ALL_OBJECTS = $(BOOT_OBJECTS) $(KERNEL_OBJECTS) $(LIB_OBJECTS) $(SHELL_OBJECTS)

.PHONY: all clean run iso img kernel

all: $(ISO)

# Build bootloader
$(BOOT_DIR)/stage1.o: $(BOOT_DIR)/stage1.S
	$(AS) $(ASFLAGS) $< -o $@

$(BOOT_DIR)/stage2.o: $(BOOT_DIR)/stage2.S
	$(AS) $(ASFLAGS) $< -o $@

# Build kernel
$(KERNEL_DIR)/%.o: $(KERNEL_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

# Build libc
$(LIB_DIR)/%.o: $(LIB_DIR)/%.c
	$(CC) $(CFLAGS) -I. -c $< -o $@

# Build shell
$(SHELL_DIR)/%.o: $(SHELL_DIR)/%.c
	$(CC) $(CFLAGS) -I. -c $< -o $@

# Link everything
kernel.elf: $(ALL_OBJECTS)
	$(LD) $(LDFLAGS) $^ -o $@

# Create flat binary
$(KERNEL_BIN): kernel.elf
	$(OBJCOPY) -O binary -R .note -R .comment -S $< $@

# Build ISO
$(ISO): kernel.bin $(BOOT_DIR)/stage1.bin $(BOOT_DIR)/stage2.bin
	@mkdir -p $(ISO_DIR)/boot/grub
	cp $(BOOT_DIR)/stage1.bin $(ISO_DIR)/boot/
	cp $(KERNEL_BIN) $(ISO_DIR)/boot/
	cp $(BOOT_DIR)/stage2.bin $(ISO_DIR)/boot/
	
	cat > $(ISO_DIR)/boot/grub/grub.cfg << EOF
	menuentry "NanoOS" {
	    insmod part_msdos
	    insmod ext2
	    set root='(hd0)'
	    multiboot /boot/kernel.bin
	}
	EOF
	
	grub-mkrescue -o $@ $(ISO_DIR) 2>/dev/null || echo "Note: Install grub-common for ISO generation"

# Alternative: Create floppy image
$(OS-img): kernel.bin $(BOOT_DIR)/stage1.bin
	dd if=/dev/zero of=$@ bs=1024 count=1440 2>/dev/null
	dd if=$(BOOT_DIR)/stage1.bin of=$@ conv=notrunc 2>/dev/null
	dd if=$(KERNEL_BIN) of=$@ seek=1 bs=512 conv=notrunc 2>/dev/null

# Run in QEMU
run: $(ISO)
	@if command -v qemu-system-i386 &> /dev/null; then \
		qemu-system-i386 -cdrom $(ISO) -m 64; \
	else \
		echo "QEMU not installed. Install with: sudo apt install qemu-system-x86"; \
	fi

# Clean
clean:
	rm -f $(ALL_OBJECTS) kernel.elf $(KERNEL_BIN) $(ISO) $(OS-img)
	rm -rf $(ISO_DIR)/boot
