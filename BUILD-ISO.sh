#!/bin/bash
#
# ============================================
# MyWinOS - Build Custom Windows-Like OS ISO
# ============================================
# Script untuk membuat custom lightweight Linux
# dengan tampilan seperti Windows 10/11
#
# Usage: sudo ./BUILD-ISO.sh
#

set -e

# ============================================
# KONFIGURASI
# ============================================

# Warna untuk output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Direktori kerja
WORK_DIR="/workspace/project/MyWinOS"
BUILD_DIR="$WORK_DIR/build"
OUTPUT_DIR="$WORK_DIR/output"
ISO_NAME="MyWinOS-1.0-amd64.iso"
INSTALL_DIR="$BUILD_DIR/chroot"

# ============================================
# FUNGSI-FUNGSI
# ============================================

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Cek apakah running sebagai root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "Script ini harus dijalankan sebagai root!"
        log_info "Usage: sudo $0"
        exit 1
    fi
}

# Cek dependensi
check_dependencies() {
    log_info "Memeriksa dependensi..."
    
    local deps=("debootstrap" "squashfs-tools" "genisoimage" "xorriso" "qemu-utils" "dialog")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        log_warning "Dependensi yang hilang: ${missing[*]}"
        log_info "Menginstall dependensi..."
        apt update
        apt install -y "${missing[@]}"
    fi
    
    log_success "Semua dependensi terpenuhi"
}

# Buat struktur direktori
create_directories() {
    log_info "Membuat struktur direktori..."
    
    mkdir -p "$BUILD_DIR"
    mkdir -p "$OUTPUT_DIR"
    mkdir -p "$INSTALL_DIR"
    
    log_success "Struktur direktori siap"
}

# Install base system Debian/Ubuntu
install_base_system() {
    log_info "Menginstall base system..."
    
    # Menggunakan debootstrap untuk install base system
    debootstrap --arch=amd64 --variant=minbase jammy "$INSTALL_DIR" http://archive.ubuntu.com/ubuntu/
    
    # Mount pseudo-filesystems
    mount -t proc none "$INSTALL_DIR/proc"
    mount -t sysfs none "$INSTALL_DIR/sys"
    mount -o bind /dev "$INSTALL_DIR/dev"
    
    log_success "Base system terinstall"
}

# Configure base system
configure_base_system() {
    log_info "Mengconfigure base system..."
    
    # Copy DNS config
    cp /etc/resolv.conf "$INSTALL_DIR/etc/resolv.conf"
    cp /etc/hosts "$INSTALL_DIR/etc/hosts"
    
    # Set hostname
    echo "mywinos" > "$INSTALL_DIR/etc/hostname"
    
    # Configure apt
    cat > "$INSTALL_DIR/etc/apt/sources.list" << 'EOF'
deb http://archive.ubuntu.com/ubuntu/ jammy main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ jammy-updates main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse
EOF
    
    # Update package list
    chroot "$INSTALL_DIR" apt update
    
    log_success "Base system terkonfigurasi"
}

# Install XFCE Desktop dan aplikasi
install_desktop_environment() {
    log_info "Menginstall XFCE Desktop Environment..."
    
    # Install kernel
    chroot "$INSTALL_DIR" apt install -y linux-image-generic
    
    # Install bootloader
    chroot "$INSTALL_DIR" apt install -y grub2 grub-pc
    
    # Install XFCE desktop
    chroot "$INSTALL_DIR" apt install -y \
        xfce4 \
        xfce4-goodies \
        lightdm \
        lightdm-gtk-greeter \
        gtk2-engines-murrine \
        gtk2-engines-pixbuf \
        xfwm4-themes \
        gnome-icon-theme
    
    # Install aplikasi dasar
    chroot "$INSTALL_DIR" apt install -y \
        firefox \
        libreoffice-calc \
        libreoffice-writer \
        libreoffice-impress \
        vlc \
        audacious \
        viewnior \
        gnome-disk-utility \
        gparted \
        gnome-screenshot \
        xfce4-terminal \
        mousepad \
        file-roller \
        gnome-software \
        network-manager \
        ubuntu-drivers-common \
        linux-firmware
    
    # Install language pack
    chroot "$INSTALL_DIR" apt install -y language-pack-id language-pack-id-base
    
    log_success "Desktop environment terinstall"
}

# Install Windows themes
install_windows_themes() {
    log_info "Menginstall Windows themes..."
    
    # Buat direktori themes
    mkdir -p "$INSTALL_DIR/root/.themes"
    mkdir -p "$INSTALL_DIR/root/.icons"
    
    # Clone Windows 10 theme
    if command -v git &> /dev/null; then
        cd /tmp
        git clone --depth 1 https://github.com/B00merang-Project/Windows-10-Transformation.git
        cp -r Windows-10-Transformation/* "$INSTALL_DIR/root/.themes/"
        
        git clone --depth 1 https://github.com/B00merang-Project/Windows-11-Transformation.git
        cp -r Windows-11-Transformation/* "$INSTALL_DIR/root/.themes/"
    fi
    
    # Buat theme config
    mkdir -p "$INSTALL_DIR/etc/skel/.config/xfce4"
    cat > "$INSTALL_DIR/etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfwm4" version="1.0">
  <property name="general" type="empty">
    <property name="activation_dialog_theme" type="empty"/>
    <property name="borderless_maximize" type="bool" value="true"/>
    <property name="box_move" type="bool" value="false"/>
    <property name="box_resize" type="bool" value="false"/>
    <property name="button_layout" type="string" value="O|HMC"/>
    <property name="button_offset" type="int" value="0"/>
    <property name="button_spacing" type="int" value="0"/>
    <property name="click_to_focus" type="bool" value="true"/>
    <property name="cycle_apps" type="string" value=""/>
    <property name="cycle_minimized" type="bool" value="false"/>
    <property name="cycle_preview" type="bool" value="true"/>
    <property name="cycle_with_tabs" type="bool" value="true"/>
    <property name="dark_disabled" type="bool" value="false"/>
    <property name="dark_sideborders" type="bool" value="false"/>
    <property name="desktp_menu" type="bool" value="true"/>
    <property name="easy_click" type="string" value="Alt"/>
    <property name="focus_delay" type="int" value="0"/>
    <property name="focus_hint" type="bool" value="true"/>
    <property name="focus_new" type="bool" value="true"/>
    <property name="frame_opacity" type="int" value="100"/>
    <property name="frame_radius" type="int" value="8"/>
    <property name="full_width_title" type="bool" value="true"/>
    <property name="inactive_opacity" type="int" value="100"/>
    <property name="maximized_offset" type="int" value="0"/>
    <property name="middle_click_close" type="bool" value="false"/>
    <property name="minimized_opacity" type="int" value="100"/>
    <property name="move_opacity" type="int" value="100"/>
    <property name="pluck" type="bool" value="false"/>
    <property name="pluck_mode" type="string" value="C"/>
    <property name="popup_opacity" type="int" value="100"/>
    <property name="raise_delay" type="int" value="250"/>
    <property name="raise_on_focus" type="bool" value="true"/>
    <property name="raise_on_interactive_close" type="bool" value="false"/>
    <property name="repeat_urgent_alert" type="bool" value="true"/>
    <property name="resize_opacity" type="int" value="100"/>
    <property name="restore_on_move" type="bool" value="true"/>
    <property name="scroll_workspaces" type="bool" value="true"/>
    <property name="shadow_delta_height" type="int" value="3"/>
    <property name="shadow_delta_width" type="int" value="3"/>
    <property name="shadow_delta_x" type="int" value="0"/>
    <property name="shadow_delta_y" type="int" value="-3"/>
    <property name="shadow_opacity" type="int" value="50"/>
    <property name="show_dock_shadow" type="bool" value="false"/>
    <property name="show_popup_shadow" type="bool" value="false"/>
    <property name="snap_to_border" type="bool" value="true"/>
    <property name="snap_to_windows" type="bool" value="true"/>
    <property name="suspend_shadows" type="bool" value="false"/>
    <property name="theme" type="string" value="Windows-10-Dark"/>
    <property name="tile_animation" type="int" value="1"/>
    <property name="title_font" type="string" value="Segoe UI Bold 9"/>
    <property name="title_horizontal_offset" type="int" value="0"/>
    <property name="title_shadow_active" type="string" value="false"/>
    <property name="title_shadow_inactive" type="string" value="false"/>
    <property name="title_vertical_offset" type="int" value="0"/>
    <property name="toggle_workspaces" type="bool" value="false"/>
    <property name="unredirect_overlay" type="bool" value="true"/>
    <property name="urgent_blink" type="bool" value="false"/>
    <property name="urgent_seconds_first" type="bool" value="true"/>
    <property name="use_compositing" type="bool" value="false"/>
    <property name="use_image_buffer" type="bool" value="true"/>
    <property name="workspace_count" type="int" value="4"/>
    <property name="wrap_cycle" type="bool" value="true"/>
    <property name="wrap_layout" type="bool" value="true"/>
    <property name="wrap_resources" type="bool" value="true"/>
    <property name="wrap_windows" type="bool" value="true"/>
    <property name="wrappable" type="string" value=""/>
  </property>
</channel>
EOF
    
    log_success "Windows themes terinstall"
}

# Configure user dan system
configure_system() {
    log_info "Mengconfigure sistem..."
    
    # Set timezone
    chroot "$INSTALL_DIR" ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
    
    # Set locale
    chroot "$INSTALL_DIR" apt install -y locales
    echo "en_US.UTF-8 UTF-8" > "$INSTALL_DIR/etc/locale.gen"
    echo "id_ID.UTF-8 UTF-8" >> "$INSTALL_DIR/etc/locale.gen"
    chroot "$INSTALL_DIR" locale-gen
    chroot "$INSTALL_DIR" update-locale LANG=en_US.UTF-8
    
    # Set keyboard (Indonesia)
    cat > "$INSTALL_DIR/etc/default/keyboard" << 'EOF'
XKBMODEL="pc105"
XKBLAYOUT="us,id"
XKBVARIANT=",intl"
XKBOPTIONS="grp:alt_shift_toggle"
BACKSPACE="guess"
EOF
    
    # Set LightDM autologin
    cat > "$INSTALL_DIR/etc/lightdm/lightdm.conf" << 'EOF'
[Seat:*]
autologin-user=mywinos
autologin-user-timeout=0
user-session=xfce
allow-guest=false
greeter-hide-users=false
EOF
    
    # Buat user default
    chroot "$INSTALL_DIR" useradd -m -s /bin/bash -G sudo mywinos
    echo "mywinos:mywinos" | chroot "$INSTALL_DIR" chpasswd
    
    # Set default wallpaper (solid color placeholder)
    mkdir -p "$INSTALL_DIR/etc/skel/Pictures"
    convert -size 1920x1080 gradient:"#0078D4-#005A9E" "$INSTALL_DIR/etc/skel/Pictures/wallpaper.png" 2>/dev/null || \
    echo "Blue gradient wallpaper" > "$INSTALL_DIR/etc/skel/Pictures/wallpaper.txt"
    
    log_success "Sistem terkonfigurasi"
}

# Optimize untuk performa
optimize_system() {
    log_info "Mengoptimasi sistem untuk performa..."
    
    # Optimize sysctl
    cat > "$INSTALL_DIR/etc/sysctl.d/99-mywinos.conf" << 'EOF'
# Swappiness
vm.swappiness=10
vm.vfs_cache_pressure=50

# Network
net.core.rmem_max=16777216
net.core.wmem_max=16777216

# File system
fs.inotify.max_user_watches=524288
EOF
    
    # Disable unnecessary services
    chroot "$INSTALL_DIR" systemctl disable snapd 2>/dev/null || true
    chroot "$INSTALL_DIR" systemctl mask systemd-networkd-wait-online 2>/dev/null || true
    
    log_success "Optimasi selesai"
}

# Create SquashFS
create_squashfs() {
    log_info "Membuat SquashFS..."
    
    # Umount pseudo-filesystems
    umount "$INSTALL_DIR/proc" 2>/dev/null || true
    umount "$INSTALL_DIR/sys" 2>/dev/null || true
    umount "$INSTALL_DIR/dev" 2>/dev/null || true
    
    # Create squashfs
    mksquashfs "$INSTALL_DIR" "$BUILD_DIR/filesystem.squashfs" -comp xz -b 131072
    
    log_success "SquashFS dibuat"
}

# Create ISO
create_iso() {
    log_info "Membuat ISO..."
    
    cd "$BUILD_DIR"
    
    # Buat direktori ISO
    mkdir -p iso/boot/grub
    mkdir -p iso/live
    
    # Copy kernel dan initrd
    cp "$INSTALL_DIR"/boot/vmlinuz-* iso/live/vmlinuz 2>/dev/null || \
    cp "$INSTALL_DIR"/boot/kernel-* iso/live/vmlinuz 2>/dev/null || \
    echo "vmlinuz not found"
    
    cp "$INSTALL_DIR"/boot/initrd.img-* iso/live/initrd.img 2>/dev/null || \
    cp "$INSTALL_DIR"/boot/initrd.img iso/live/initrd.img 2>/dev/null || \
    echo "initrd not found"
    
    # Copy squashfs
    cp "$BUILD_DIR/filesystem.squashfs" iso/live/
    
    # Buat grub config
    cat > iso/boot/grub/grub.cfg << 'EOF'
set timeout=5
set default=0

menuentry "MyWinOS - Windows-Like Linux" {
    linux /live/vmlinuz boot=casper quiet splash
    initrd /live/initrd.img
}

menuentry "MyWinOS - Recovery Mode" {
    linux /live/vmlinuz boot=casper recovery nomodeset
    initrd /live/initrd.img
}
EOF
    
    # Buat manifest
    cat > iso/live/filesystem.packages << 'EOF'
# Base System
linux-image-generic
grub2
grub-pc

# Desktop Environment
xfce4
xfce4-goodies
lightdm
lightdm-gtk-greeter

# Applications
firefox
libreoffice-calc
libreoffice-writer
libreoffice-impress
vlc
audacious
viewnior

# System Tools
network-manager
ubuntu-drivers-common
EOF
    
    # Generate ISO
    xorriso -as mkisofs \
        -r \
        -J \
        -boot-load-size 4 \
        -boot-info-table \
        -no-emul-boot \
        -partition_offset 16 \
        -m 'proc' -m 'sys' -m 'run' \
        -o "$OUTPUT_DIR/$ISO_NAME" \
        iso/
    
    log_success "ISO dibuat: $OUTPUT_DIR/$ISO_NAME"
}

# Cleanup
cleanup() {
    log_info "Membersihkan file temporary..."
    
    rm -rf "$BUILD_DIR"
    rm -rf "$INSTALL_DIR"
    
    log_success "Cleanup selesai"
}

# ============================================
# MAIN PROGRAM
# ============================================

main() {
    echo "============================================"
    echo "  MyWinOS - Build Custom Windows-Like OS   "
    echo "============================================"
    echo ""
    
    check_root
    check_dependencies
    create_directories
    
    echo ""
    echo "Pilih mode build:"
    echo "1) Full Build (install semua komponen)"
    echo "2) Quick Build (base system only)"
    echo "3) Exit"
    echo ""
    read -p "Pilihan [1-3]: " choice
    
    case $choice in
        1)
            log_info "Memulai Full Build..."
            install_base_system
            configure_base_system
            install_desktop_environment
            install_windows_themes
            configure_system
            optimize_system
            create_squashfs
            create_iso
            ;;
        2)
            log_info "Memulai Quick Build..."
            install_base_system
            configure_base_system
            configure_system
            optimize_system
            create_squashfs
            create_iso
            ;;
        3)
            log_info "Keluar..."
            exit 0
            ;;
        *)
            log_error "Pilihan tidak valid!"
            exit 1
            ;;
    esac
    
    echo ""
    echo "============================================"
    echo "           Build Selesai! 🎉              "
    echo "============================================"
    echo ""
    log_info "ISO tersimpan di: $OUTPUT_DIR/$ISO_NAME"
    echo ""
    echo "Langkah selanjutnya:"
    echo "1. Buat USB bootable dengan Rufus/Ventoy"
    echo "2. Boot dari USB"
    echo "3. Install MyWinOS ke komputer"
    echo ""
}

# Jalankan main
main "$@"
