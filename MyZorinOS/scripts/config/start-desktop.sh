#!/bin/bash
# MyZorinOS Desktop Session Starter
# Script untuk memulai desktop environment

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "Starting MyZorinOS Desktop..."

# Load user configuration
CONFIG_FILE="$HOME/.config/myzorinos/layout.json"
if [ -f "$CONFIG_FILE" ]; then
    LAYOUT=$(grep -o '"layout": *"[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)
else
    LAYOUT="windows"
fi

echo "Using layout: $LAYOUT"

# Apply layout configuration
apply_layout() {
    local layout=$1
    local config_file="$HOME/.config/myzorinos/panels/panel.json"
    
    if [ -f "$PROJECT_DIR/appearance/layouts/${layout}-layout.json" ]; then
        echo "Applying $layout layout..."
    fi
    
    # Create panel config based on layout
    case $layout in
        windows)
            cat > "$config_file" << 'EOF'
{
    "position": "bottom",
    "height": 40,
    "autohide": false,
    "elements": {
        "start_button": {"visible": true},
        "taskbar": {"visible": true},
        "system_tray": {"visible": true}
    }
}
EOF
            ;;
        macos)
            cat > "$config_file" << 'EOF'
{
    "position": "top",
    "height": 25,
    "autohide": false,
    "elements": {
        "menu_bar": {"visible": true},
        "system_tray": {"visible": true}
    }
}
EOF
            ;;
        linux)
            cat > "$config_file" << 'EOF'
{
    "position": "top",
    "height": 32,
    "autohide": false,
    "elements": {
        "applications_menu": {"visible": true},
        "window_list": {"visible": true},
        "system_tray": {"visible": true},
        "workspace_switcher": {"visible": true}
    }
}
EOF
            ;;
    esac
}

# Start compositor
start_compositor() {
    # Kill existing compositor
    pkill -9 picom 2>/dev/null || true
    pkill -9 compton 2>/dev/null || true
    
    # Start picom
    if [ -f "$PROJECT_DIR/desktop-environment/compositor/compositor.conf" ]; then
        picom -c "$PROJECT_DIR/desktop-environment/compositor/compositor.conf" --daemon &
    else
        picom --daemon &
    fi
    
    echo "Compositor started"
}

# Start panel
start_panel() {
    # Kill existing panel
    pkill -9 xfce4-panel 2>/dev/null || true
    
    # Wait a bit
    sleep 0.5
    
    # Start panel with custom configuration
    xfce4-panel --disable-wm-check &
    
    echo "Panel started"
}

# Start notification daemon
start_notifications() {
    pkill -9 xfce4-notifyd 2>/dev/null || true
    xfce4-notifyd &
    echo "Notification daemon started"
}

# Start desktop icons
start_desktop_icons() {
    if command -v xfdesktop &> /dev/null; then
        pkill -9 xfdesktop 2>/dev/null || true
        xfdesktop &
        echo "Desktop icons started"
    fi
}

# Set wallpaper
set_wallpaper() {
    local wallpaper_dir="$PROJECT_DIR/appearance/wallpapers"
    local wallpaper="$wallpaper_dir/default.jpg"
    
    if [ -f "$wallpaper" ]; then
        xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s "$wallpaper" 2>/dev/null || true
    fi
}

# Apply theme
apply_theme() {
    local theme="MyZorinOS Dark"
    
    if [ -d "$HOME/.themes/$theme" ]; then
        xfconf-query -c xsettings -p /Net/ThemeName -s "$theme" 2>/dev/null || true
    fi
}

# Main startup sequence
main() {
    apply_layout "$LAYOUT"
    start_compositor
    start_notifications
    start_panel
    start_desktop_icons
    set_wallpaper
    apply_theme
    
    echo "MyZorinOS Desktop started successfully!"
}

main "$@"