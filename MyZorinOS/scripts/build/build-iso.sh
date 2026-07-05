#!/bin/bash
# MyZorinOS ISO Build Script
# Membuat bootable ISO dari MyZorinOS

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$PROJECT_DIR/build"
ISO_DIR="$BUILD_DIR/iso"
ISO_OUTPUT="$BUILD_DIR/myzorinos.iso"

VERSION="1.0.0"

echo "========================================"
echo "MyZorinOS ISO Build Script"
echo "Version: $VERSION"
echo "========================================"
echo ""

# Create build directory
mkdir -p "$ISO_DIR"

# Copy files to build directory
echo "Copying files..."
rsync -a "$PROJECT_DIR"/* "$ISO_DIR/" --exclude=".git" --exclude="build" --exclude="*.iso"

# Create filesystem.squashfs
echo "Creating squashfs..."
cd "$ISO_DIR"
mksquashfs . "$BUILD_DIR/filesystem.squashfs" -comp xz -e var/cache/apt

# Create kernel and initrd (placeholder - would need actual kernel)
echo "Creating boot image..."
mkdir -p "$BUILD_DIR/casper"
# cp /boot/vmlinuz "$BUILD_DIR/casper/vmlinuz"
# cp /boot/initrd.img "$BUILD_DIR/casper/initrd.gz"

# Create manifest
echo "Creating manifest..."
dpkg-query -W --showformat='${Package} ${Version}\n' > "$BUILD_DIR/casper/filesystem.manifest"

# Create ISO
echo "Creating ISO..."
cd "$BUILD_DIR"
xorriso -as mkisofs \
    -iso-level 3 \
    -full-iso-level 3 \
    -eltorito-boot boot/grub/bios.img \
    -no-emul-boot \
    -boot-load-size 4 \
    -boot-info-table \
    -eltorito-catalog boot/boot.cat \
    -output "$ISO_OUTPUT" \
    -iso-level 3 \
    -zisofs \
    "$BUILD_DIR"

echo ""
echo "========================================"
echo -e "${GREEN}ISO created successfully!${NC}"
echo "Output: $ISO_OUTPUT"
echo "========================================"