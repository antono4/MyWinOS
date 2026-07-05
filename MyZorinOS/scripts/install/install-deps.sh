#!/bin/bash
# MyZorinOS - Install Dependencies
# Script untuk menginstall dependencies yang diperlukan

set -e

echo "========================================"
echo "MyZorinOS - Installing Dependencies"
echo "========================================"

# Check if running as root or with sudo
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or with sudo"
    exit 1
fi

# Detect distribution
if [ -f /etc/debian_version ]; then
    PKG_MANAGER="apt-get"
    echo "Detected Debian/Ubuntu-based system"
elif [ -f /etc/redhat-release ]; then
    PKG_MANAGER="dnf"
    echo "Detected Red Hat/Fedora-based system"
elif [ -f /etc/arch-release ]; then
    PKG_MANAGER="pacman"
    echo "Detected Arch Linux"
else
    echo "Unknown distribution. Please install dependencies manually."
    exit 1
fi

echo ""
echo "Installing base packages..."

if [ "$PKG_MANAGER" = "apt-get" ]; then
    apt-get update
    apt-get install -y \
        git \
        build-essential \
        cmake \
        meson \
        ninja-build \
        gettext \
        autopoint \
        libtool \
        pkg-config \
        gtk-3-dev \
        libgtk-3-dev \
        libglib2.0-dev \
        libgdk-pixbuf-2.0-dev \
        libpango1.0-dev \
        libatk1.0-dev \
        libcairo2-dev \
        libx11-dev \
        libxext-dev \
        libxinerama-dev \
        libxrandr-dev \
        libxfixes-dev \
        libxcursor-dev \
        libxcomposite-dev \
        libxdamage-dev \
        libxi-dev \
        libxtst-dev \
        libxkbcommon-dev \
        libdbus-glib-1-dev \
        libpulse-dev \
        libnotify-dev \
        libsecret-1-dev \
        libhandy-1-dev \
        libadwaita-1-dev \
        python3 \
        python3-gi \
        python3-gi-cairo \
        gir1.2-gtk-3.0 \
        gir1.2-glib-2.0 \
        gir1.2-handy-1 \
        gir1.2-wnck-3.0 \
        xfce4 \
        xfce4-panel \
        xfce4-session \
        xfce4-settings \
        xfce4-terminal \
        xfce4-notifyd \
        xfce4-battery-plugin \
        xfce4-pulseaudio-plugin \
        xfwm4 \
        xfwm4-themes \
        thunar \
        thunar-archive-plugin \
        thunar-volman \
        mousepad \
        xfce4-taskmanager \
        xfce4-screenshooter \
        xfce4-clipman-plugin \
        xfce4-dict \
        xfce4-datetime-plugin \
        xfce4-mount-plugin \
        xfce4-cpufreq-plugin \
        xfce4-diskperf-plugin \
        xfce4-fsguard-plugin \
        xfce4-genmon-plugin \
        xfce4-mailwatch-plugin \
        xfce4-netload-plugin \
        xfce4-notes-plugin \
        xfce4-places-plugin \
        xfce4-sensors-plugin \
        xfce4-systemload-plugin \
        xfce4-timer-plugin \
        xfce4-verve-plugin \
        xfce4-wavelan-plugin \
        xfce4-weather-plugin \
        xfce4-xkb-plugin \
        xfce4-windowck-plugin \
        xfce4-docklike-plugin \
        xfce4-panel-profiles \
        libnotify-bin \
        policykit-1 \
        udiskie \
        udisks2 \
        gvfs-backends \
        gvfs-fuse \
        xdg-user-dirs-gtk \
        xdg-utils \
        gnome-control-center \
        gnome-session \
        gnome-themes-extra \
        arc-theme \
        papirus-icon-theme \
        fonts-cantarell \
        fonts-dejavu \
        fonts-droid-fallback \
        fonts-freefont-ttf \
        fonts-liberation \
        fonts-noto \
        fonts-opensymbol \
        fonts-symbola \
        fonts-ubuntu \
        x11-apps \
        x11-utils \
        x11-xserver-utils \
        dbus-x11 \
        unclutter \
        compton \
        picom \
        nitrogen \
        rofi \
        alacarte \
        menu-cache-utils

elif [ "$PKG_MANAGER" = "dnf" ]; then
    dnf install -y \
        git \
        @development-tools \
        cmake \
        gettext \
        gtk3-devel \
        glib2-devel \
        gdk-pixbuf2-devel \
        pango-devel \
        atk-devel \
        cairo-devel \
        libX11-devel \
        libXext-devel \
        libXinerama-devel \
        libXrandr-devel \
        libXfixes-devel \
        libXcursor-devel \
        libXcomposite-devel \
        libXdamage-devel \
        libXi-devel \
        libXtst-devel \
        libxkbcommon-devel \
        dbus-glib-devel \
        pulseaudio-libs-devel \
        libnotify-devel \
        libsecret-devel \
        python3 \
        py3gobject \
        pygobject3 \
        xfce4-panel \
        xfce4-session \
        xfce4-settings \
        xfce4-terminal \
        xfwm4 \
        Thunar \
        mousepad \
        xfce4-appfinder \
        arc-theme \
        papirus-icon-theme

elif [ "$PKG_MANAGER" = "pacman" ]; then
    pacman -Sy --noconfirm \
        git \
        base-devel \
        cmake \
        gettext \
        gtk3 \
        glib2 \
        gdk-pixbuf2 \
        pango \
        atk \
        cairo \
        libx11 \
        libxext \
        libxinerama \
        libxrandr \
        libxfixes \
        libxcursor \
        libxcomposite \
        libxdamage \
        libxi \
        libxtst \
        xkbcommon \
        dbus-glib \
        libpulse \
        libnotify \
        libsecret \
        python \
        python-gobject \
        xfce4 \
        xfce4-goodies \
        thunar \
        mousepad \
        arc-gtk-theme \
        papirus-icon-theme
fi

echo ""
echo "========================================"
echo "Dependencies installed successfully!"
echo "========================================"
echo ""
echo "Now you can build MyZorinOS with:"
echo "  sudo ./scripts/build/build-os.sh"
echo ""