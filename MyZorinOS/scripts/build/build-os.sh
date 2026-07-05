#!/bin/bash
# MyZorinOS - Build Script
# Script utama untuk membangun MyZorinOS

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "========================================"
echo "MyZorinOS Build Script"
echo "========================================"
echo ""

# Load configuration
source "$PROJECT_DIR/config/build.conf" 2>/dev/null || true

# Default values
: "${BUILD_TYPE:=full}"
: "${INSTALL_PATH:=/opt/myzorinos}"
: "${THEME_NAME:=myzorinos-dark}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Check for required tools
check_requirements() {
    log_info "Checking requirements..."
    
    local missing=()
    
    for cmd in git gcc g++ make cmake pkg-config; do
        if ! command -v $cmd &> /dev/null; then
            missing+=($cmd)
        fi
    done
    
    if [ ${#missing[@]} -ne 0 ]; then
        log_error "Missing required tools: ${missing[*]}"
        log_info "Please install dependencies first:"
        log_info "  sudo ./scripts/install/install-deps.sh"
        exit 1
    fi
    
    log_success "All requirements met"
}

# Install themes
install_themes() {
    log_info "Installing themes..."
    
    local themes_dir="$PROJECT_DIR/appearance/themes"
    local install_dir="$INSTALL_PATH/share/themes"
    
    mkdir -p "$install_dir"
    
    for theme in "$themes_dir"/*/; do
        if [ -d "$theme" ]; then
            theme_name=$(basename "$theme")
            log_info "  Installing theme: $theme_name"
            cp -r "$theme" "$install_dir/"
        fi
    done
    
    log_success "Themes installed"
}

# Install layouts
install_layouts() {
    log_info "Installing layouts..."
    
    local layouts_dir="$PROJECT_DIR/appearance/layouts"
    local install_dir="$INSTALL_PATH/share/myzorinos/layouts"
    
    mkdir -p "$install_dir"
    cp -r "$layouts_dir"/* "$install_dir/"
    
    log_success "Layouts installed"
}

# Install wallpapers
install_wallpapers() {
    log_info "Installing wallpapers..."
    
    local wallpapers_dir="$PROJECT_DIR/appearance/wallpapers"
    local install_dir="$INSTALL_PATH/share/myzorinos/wallpapers"
    
    mkdir -p "$install_dir"
    
    if [ -d "$wallpapers_dir" ]; then
        cp -r "$wallpapers_dir"/* "$install_dir/"
    else
        log_warning "No wallpapers found in $wallpapers_dir"
    fi
    
    log_success "Wallpapers installed"
}

# Install icons
install_icons() {
    log_info "Installing icon themes..."
    
    local icons_dir="$PROJECT_DIR/appearance/icons"
    local install_dir="$INSTALL_PATH/share/icons"
    
    mkdir -p "$install_dir"
    
    if [ -d "$icons_dir" ]; then
        for icon_theme in "$icons_dir"/*/; do
            if [ -d "$icon_theme" ]; then
                theme_name=$(basename "$icon_theme")
                log_info "  Installing icon theme: $theme_name"
                cp -r "$icon_theme" "$install_dir/"
            fi
        done
    fi
    
    log_success "Icon themes installed"
}

# Install desktop files
install_desktop_files() {
    log_info "Installing desktop files..."
    
    local app_dir="$INSTALL_PATH/share/applications"
    mkdir -p "$app_dir"
    
    # Zorin Appearance
    cat > "$app_dir/myzorinos-appearance.desktop" << 'EOF'
[Desktop Entry]
Name=MyZorinOS Appearance
Comment=Customize your desktop
Exec=/opt/myzorinos/bin/zorin-appearance
Icon=preferences-desktop-theme
Terminal=false
Type=Application
Categories=Settings;DesktopSettings;X-XFCE-Settings-Panel;
Keywords=theme;background;desktop;appearance;
EOF

    # Zorin Settings
    cat > "$app_dir/myzorinos-settings.desktop" << 'EOF'
[Desktop Entry]
Name=MyZorinOS Settings
Comment=System settings and preferences
Exec=/opt/myzorinos/bin/zorin-settings
Icon=preferences-system
Terminal=false
Type=Application
Categories=Settings;X-XFCE-Settings-Panel;
Keywords=settings;system;preferences;
EOF

    log_success "Desktop files installed"
}

# Install applications
install_apps() {
    log_info "Installing applications..."
    
    local app_dir="$INSTALL_PATH/bin"
    local python_apps="$PROJECT_DIR/apps"
    
    mkdir -p "$app_dir"
    
    # Desktop Manager
    if [ -f "$PROJECT_DIR/desktop-environment/desktop-manager.py" ]; then
        cp "$PROJECT_DIR/desktop-environment/desktop-manager.py" "$app_dir/desktop-manager"
        chmod +x "$app_dir/desktop-manager"
    fi
    
    # Zorin Appearance
    if [ -f "$python_apps/zorin-appearance/app.py" ]; then
        cp "$python_apps/zorin-appearance/app.py" "$app_dir/zorin-appearance"
        chmod +x "$app_dir/zorin-appearance"
    fi
    
    # Zorin Settings
    if [ -f "$python_apps/zorin-settings/app.py" ]; then
        cp "$python_apps/zorin-settings/app.py" "$app_dir/zorin-settings"
        chmod +x "$app_dir/zorin-settings"
    fi
    
    log_success "Applications installed"
}

# Configure system
configure_system() {
    log_info "Configuring system..."
    
    # Create user config directory
    local user_config="$HOME/.config/myzorinos"
    mkdir -p "$user_config/panels"
    mkdir -p "$user_config/layouts"
    mkdir -p "$user_config/themes"
    
    # Copy default layout config
    if [ ! -f "$user_config/layout.json" ]; then
        cat > "$user_config/layout.json" << 'EOF'
{
    "layout": "windows",
    "theme": "myzorinos-dark",
    "wallpaper": "default"
}
EOF
    fi
    
    # Setup autostart
    local autostart="$HOME/.config/autostart"
    mkdir -p "$autostart"
    
    cat > "$autostart/myzorinos-desktop.desktop" << EOF
[Desktop Entry]
Type=Application
Name=MyZorinOS Desktop
Exec=$INSTALL_PATH/bin/desktop-manager
Hidden=false
NoDisplay=true
X-GNOME-Autostart-enabled=true
EOF

    log_success "System configured"
}

# Main build process
main() {
    echo "Build Type: $BUILD_TYPE"
    echo "Install Path: $INSTALL_PATH"
    echo "Theme: $THEME_NAME"
    echo ""
    
    check_requirements
    
    log_info "Starting build process..."
    echo ""
    
    # Create install directory
    mkdir -p "$INSTALL_PATH"
    
    # Install components
    install_themes
    install_layouts
    install_wallpapers
    install_icons
    install_desktop_files
    install_apps
    configure_system
    
    echo ""
    echo "========================================"
    log_success "MyZorinOS built successfully!"
    echo "========================================"
    echo ""
    echo "To start MyZorinOS desktop:"
    echo "  1. Log out and select MyZorinOS session from login screen"
    echo "  OR"
    echo "  2. Run: startx"
    echo ""
    echo "To configure appearance:"
    echo "  $INSTALL_PATH/bin/zorin-appearance"
    echo ""
    echo "To change layout:"
    echo "  $INSTALL_PATH/bin/desktop-manager --set-layout windows|macos|linux"
    echo ""
}

# Run main
main "$@"