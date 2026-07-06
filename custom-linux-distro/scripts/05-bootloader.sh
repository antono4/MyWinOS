#!/bin/bash
# =============================================================================
# LFS Build Script - Step 5: Bootloader & Kernel Installation
# =============================================================================

set -e

# Configuration
export LFS=/mnt/lfs
export LFS_TGT=$(uname -m)-lfs-linux-gnu

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_step() { echo -e "${BLUE}==>${NC} ${BLUE}$1${NC}"; }

# Check prerequisites
if [ ! -d "$LFS/etc" ]; then
    log_error "System not configured. Run 04-config-system.sh first."
    exit 1
fi

log_info "Starting Bootloader Installation..."

# =============================================================================
# Build Linux Kernel
# =============================================================================
log_step "Building Linux-6.12 Kernel..."
cd $LFS/sources
tar -xf linux-6.12.tar.xz
cd linux-6.12

# Copy kernel config if exists
if [ -f "$LFS/../config/kernel-config" ]; then
    cp "$LFS/../config/kernel-config" .config
else
    # Create minimal kernel config
    make mrproper
    make defconfig
fi

# Build kernel
make -j$(nproc)
make INSTALL_MOD_STRIP=1 modules_install

# Install kernel
cp -v arch/x86/boot/bzImage /boot/vmlinuz-6.12-lfs-12.3
cp -v System.map /boot/System.map-6.12
cp -v .config /boot/config-6.12

# Create kernel symlinks
cd /boot
ln -sfv vmlinuz-6.12-lfs-12.3 vmlinuz
ln -sfv System.map-6.12 System.map
ln -sfv config-6.12 config

cd $LFS/sources && rm -rf linux-6.12
log_info "Linux-6.12 Kernel installed"

# =============================================================================
# Build GRUB2 Bootloader
# =============================================================================
log_step "Building GRUB2..."
cd $LFS/sources
tar -xf grub-2.12.tar.xz
cd grub-2.12

mkdir -pv build && cd build
../configure --prefix=/usr \
              --host=$LFS_TGT \
              --build=$(build-aux/config.guess) \
              --disable-werror \
              --enable-bootlight
make -j$(nproc)
make DESTDIR=$LFS install -j1

# Install GRUB modules
mkdir -pv $LFS/boot/grub
GRUB_PLATFORMS="i386-pc"
for PLATFORM in $GRUB_PLATFORMS; do
    ../grub-install --host=$LFS_TGT \
                     --prefix=/usr \
                     --datarootdir=/usr/share \
                     --boot-directory=/boot \
                     --modules="normal boot linux search search_fs_uuid part_gpt part_msdos biosdisk"
done

cd $LFS/sources && rm -rf grub-2.12
log_info "GRUB2 installed"

# =============================================================================
# Configure GRUB
# =============================================================================
log_step "Configuring GRUB..."

# Create GRUB config
cat > $LFS/boot/grub/grub.cfg << "EOF"
# =============================================================================
# GRUB Configuration for My Custom Linux Distribution
# =============================================================================

# Set default menu entry
set default=0
set timeout=5

# Set menu colors
set menu_color_normal=white/black
set menu_color_highlight=black/light-gray

# Background image (optional)
# terminal_output console

# Menu entry
menuentry "My Custom Linux 12.3" {
    # Set root partition
    set root=(hd0,msdos2)
    
    # Load Linux kernel
    linux /boot/vmlinuz-6.12-lfs-12.3 root=/dev/sda2 ro quiet splash
    
    # Initrd (if needed)
    # initrd /boot/initrd.img
}

# Recovery mode
menuentry "My Custom Linux 12.3 (Recovery Mode)" {
    set root=(hd0,msdos2)
    linux /boot/vmlinuz-6.12-lfs-12.3 root=/dev/sda2 ro single
}

# Advanced options submenu
menuentry 'Advanced options for My Custom Linux' --class gnu-linux --class gnu --class os --id 'advanced' {
    submenu 'My Custom Linux 12.3 - Advanced Options' {
        menuentry 'My Custom Linux 12.3 - Kernel 6.12' {
            set root=(hd0,msdos2)
            linux /boot/vmlinuz-6.12-lfs-12.3 root=/dev/sda2 ro
        }
    }
}
EOF

# Make GRUB config readable
chmod 644 $LFS/boot/grub/grub.cfg

# =============================================================================
# Final System Setup
# =============================================================================
log_step "Performing final setup..."

# Ensure /etc/mtab exists
ln -sfv /proc/self/mounts $LFS/etc/mtab

# Set root password (default: "lfs" - SHOULD BE CHANGED!)
# Uncomment and change in production!
# chroot $LFS /usr/bin/passwd root

# Create /etc/ld.so.conf
cat > $LFS/etc/ld.so.conf << "EOF"
/usr/local/lib
/usr/lib
/lib
EOF

# Add local library path
cat >> $LFS/etc/ld.so.conf << "EOF"
/etc/ld.so.conf.d/*.conf
EOF

# Create ld.so.conf.d directory
mkdir -pv $LFS/etc/ld.so.conf.d

# =============================================================================
# Create rc.d scripts
# =============================================================================
log_step "Creating init scripts..."
mkdir -pv $LFS/etc/rc.d/rc0.d
mkdir -pv $LFS/etc/rc.d/rc1.d
mkdir -pv $LFS/etc/rc.d/rc2.d
mkdir -pv $LFS/etc/rc.d/rc3.d
mkdir -pv $LFS/etc/rc.d/rc4.d
mkdir -pv $LFS/etc/rc.d/rc5.d
mkdir -pv $LFS/etc/rc.d/rc6.d
mkdir -pv $LFS/etc/rc.d/init.d

# Create basic rc script
cat > $LFS/etc/rc.d/init.d/functions << "EOF"
#!/bin/bash
# /etc/rc.d/init.d/functions - Functions for init scripts

# Check if file exists
[ -f /lib/lsb/init-functions ] && . /lib/lsb/init-functions

# Status function
status() {
    local pid
    if [ -f "$1" ]; then
        read pid < "$1"
        if [ -d "/proc/$pid" ]; then
            echo "$2 is running (pid $pid)"
            return 0
        fi
    fi
    echo "$2 is not running"
    return 1
}

# Boot logging
log_begin_msg() {
    echo -n "$1"
}

log_end_msg() {
    if [ $1 -eq 0 ]; then
        echo " [OK]"
    else
        echo " [FAILED]"
    fi
}

# Source function files
[ -r /etc/sysconfig/rc.site ] && . /etc/sysconfig/rc.site
EOF

chmod +x $LFS/etc/rc.d/init.d/functions

# =============================================================================
# Unmount and cleanup
# =============================================================================
log_step "Performing final cleanup..."

# Save build log
if [ -f "$LFS/../build.log" ]; then
    mv "$LFS/../build.log" "$LFS/../build-$(date +%Y%m%d).log"
fi

log_info "========================================"
log_info "🎉 BOOTLOADER & KERNEL INSTALLATION COMPLETE! 🎉"
log_info "========================================"
log_info ""
log_info "Your custom Linux distribution is now ready!"
log_info ""
log_info "Next steps:"
log_info "1. Reboot and select 'My Custom Linux 12.3' from GRUB menu"
log_info "2. Login as root"
log_info "3. Change root password: passwd"
log_info "4. Configure network"
log_info "5. Create user accounts"
log_info "6. Install additional packages"
log_info ""
log_info "========================================"
log_info "SYSTEM SUMMARY"
log_info "========================================"
log_info "Kernel:     Linux 6.12"
log_info "Bootloader: GRUB 2.12"
log_info "Shell:      Bash 5.3"
log_info "Compiler:   GCC 14.2.0"
log_info "C Library:  Glibc 2.41"
log_info "Python:     3.12.7"
log_info "Editor:     Vim 9.1"
log_info "========================================"
