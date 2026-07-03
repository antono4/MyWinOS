#!/bin/bash
#
# Script untuk install Windows Theme ke XFCE
#

set -e

THEME_DIR="$HOME/.themes"
ICON_DIR="$HOME/.icons"
BACKUP_DIR="$HOME/.themes-backup-$(date +%Y%m%d%H%M%S)"

echo "=========================================="
echo "  MyWinOS - Windows Theme Installer"
echo "=========================================="

# Backup existing themes
if [ -d "$THEME_DIR" ]; then
    echo "[INFO] Backup themes lama..."
    mkdir -p "$BACKUP_DIR"
    cp -r "$THEME_DIR"/* "$BACKUP_DIR/" 2>/dev/null || true
fi

# Create directories
mkdir -p "$THEME_DIR"
mkdir -p "$ICON_DIR"

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install themes
echo "[INFO] Installing Windows 10 theme..."
if [ -d "$SCRIPT_DIR/windows-10-theme" ]; then
    cp -r "$SCRIPT_DIR/windows-10-theme" "$THEME_DIR/"
    echo "[OK] Windows 10 theme installed"
fi

if [ -d "$SCRIPT_DIR/windows-11-theme" ]; then
    cp -r "$SCRIPT_DIR/windows-11-theme" "$THEME_DIR/"
    echo "[OK] Windows 11 theme installed"
fi

# Install icons
if [ -d "$SCRIPT_DIR/icons" ]; then
    cp -r "$SCRIPT_DIR/icons/"* "$ICON_DIR/" 2>/dev/null || true
    echo "[OK] Icons installed"
fi

# Install wallpapers
if [ -d "$SCRIPT_DIR/wallpapers" ]; then
    mkdir -p "$HOME/Pictures/Wallpapers"
    cp -r "$SCRIPT_DIR/wallpapers/"* "$HOME/Pictures/Wallpapers/" 2>/dev/null || true
    echo "[OK] Wallpapers installed"
fi

# Apply theme using xfconf-query
echo "[INFO] Applying theme settings..."

# Set XFWM4 theme
xfconf-query -c xfwm4 -p /general/theme -s "Windows-10-Dark" 2>/dev/null || \
    echo "[WARN] Could not set XFWM4 theme (run in XFCE session)"

# Set GTK theme
xfconf-query -c xsettings -p /Net/ThemeName -s "Windows-10-Dark" 2>/dev/null || \
    echo "[WARN] Could not set GTK theme (run in XFCE session)"

# Set icon theme
xfconf-query -c xsettings -p /Net/IconThemeName -s "Windows-10" 2>/dev/null || \
    echo "[WARN] Could not set icon theme (run in XFCE session)"

echo ""
echo "=========================================="
echo "  Theme Installation Complete!"
echo "=========================================="
echo ""
echo "Untuk mengaktifkan theme secara manual:"
echo "1. Buka Settings → Appearance"
echo "2. Pilih tab 'Style' → Windows-10-Dark"
echo "3. Pilih tab 'Icons' → Windows-10"
echo "4. Buka Settings → Window Manager"
echo "5. Pilih 'Windows-10-Dark' theme"
echo ""
echo "Backup tersimpan di: $BACKUP_DIR"
