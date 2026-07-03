#!/bin/bash
#
# Script untuk configure XFCE Panel seperti Windows
#

echo "=========================================="
echo "  MyWinOS - Windows Panel Configuration"
echo "=========================================="

# Set primary panel (top) seperti Windows
echo "[INFO] Configuring top panel..."

# Clear existing panels
xfconf-query -c xfce4-panel -p /panels -rR 2>/dev/null || true

# Create new panel
xfconf-query -c xfce4-panel -p /panels -n -t int -s 1 2>/dev/null || true
xfconf-query -c xfce4-panel -p /panels -p /panels/panel-1/display-LWhiskermenu-1/show-button-title -n -t string -s "both" 2>/dev/null || true
xfconf-query -c xfce4-panel -p /panels/panel-1/autohide-behavior -s 0 2>/dev/null || true
xfconf-query -c xfce4-panel -p /panels/panel-1/length -s 100 2>/dev/null || true
xfconf-query -c xfce4-panel -p /panels/panel-1/size -s 32 2>/dev/null || true
xfconf-query -c xfce4-panel -p /panels/panel-1/position -s "p=0;x=0;y=0" 2>/dev/null || true
xfconf-query -c xfce4-panel -p /panels/panel-1/position-locked -s true 2>/dev/null || true

# Add items to panel
echo "[INFO] Adding panel items..."

# Item 1: Whiskermenu (Start button)
xfconf-query -c xfce4-panel -p /panels/panel-1/plugin-ids -n -t int -s 1 2>/dev/null || true

# Item 2: Separator
xfconf-query -c xfce4-panel -p /panels/panel-1/plugin-ids -n -t int -s 2 2>/dev/null || true

# Item 3: Window Buttons (taskbar)
xfconf-query -c xfce4-panel -p /panels/panel-1/plugin-ids -n -t int -s 3 2>/dev/null || true

# Item 4: Separator
xfconf-query -c xfce4-panel -p /panels/panel-1/plugin-ids -n -t int -s 4 2>/dev/null || true

# Item 5: System Tray
xfconf-query -c xfce4-panel -p /panels/panel-1/plugin-ids -n -t int -s 5 2>/dev/null || true

# Item 6: Notification Area
xfconf-query -c xfce4-panel -p /panels/panel-1/plugin-ids -n -t int -s 6 2>/dev/null || true

# Item 7: Clock
xfconf-query -c xfce4-panel -p /panels/panel-1/plugin-ids -n -t int -s 7 2>/dev/null || true

# Configure Whiskermenu
echo "[INFO] Configuring Start Menu..."
xfconf-query -c xfce4-panel -p /plugins/plugin-1 -s whiskermenu 2>/dev/null || true

# Configure Taskbar (Window Buttons)
echo "[INFO] Configuring Taskbar..."
xfconf-query -c xfce4-panel -p /plugins/plugin-3/show-handle -s false 2>/dev/null || true
xfconf-query -c xfce4-panel -p /plugins/plugin-3/flat-buttons -s true 2>/dev/null || true
xfconf-query -c xfce4-panel -p /plugins/plugin-3/rotate-wrapping -s true 2>/dev/null || true

# Configure System Tray
echo "[INFO] Configuring System Tray..."
xfconf-query -c xfce4-panel -p /plugins/plugin-5/show-handle -s false 2>/dev/null || true

# Configure Notification Area
echo "[INFO] Configuring Notification Area..."
xfconf-query -c xfce4-panel -p /plugins/plugin-6/icons-only -s false 2>/dev/null || true

# Configure Clock
echo "[INFO] Configuring Clock..."
xfconf-query -c xfce4-panel -p /plugins/plugin-7/clock-format -s "%H:%M - %d/%m/%Y" 2>/dev/null || true
xfconf-query -c xfce4-panel -p /plugins/plugin-7/tooltip-format -s "%A %d %B %Y" 2>/dev/null || true

# Restart panel to apply changes
echo "[INFO] Restarting panel..."
xfce4-panel -r 2>/dev/null || true

echo ""
echo "=========================================="
echo "  Panel Configuration Complete!"
echo "=========================================="
echo ""
echo "Jika ada kesalahan, coba:"
echo "  1. Logout dan login kembali"
echo "  2. Atau restart: xfce4-panel -r"
