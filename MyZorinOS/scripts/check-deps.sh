#!/bin/bash
# MyZorinOS Dependency Checker
# Memeriksa apakah semua dependencies terinstall

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

REQUIRED_TOOLS=(
    "git"
    "gcc"
    "g++"
    "make"
    "cmake"
    "pkg-config"
    "python3"
)

OPTIONAL_TOOLS=(
    "xfce4-panel"
    "xfce4-session"
    "xfce4-settings"
    "xfwm4"
    "thunar"
    "picom"
    "rofi"
    "nitrogen"
)

MISSING_REQUIRED=()
MISSING_OPTIONAL=()

echo "========================================"
echo "MyZorinOS Dependency Checker"
echo "========================================"
echo ""

echo "Checking required tools..."
for tool in "${REQUIRED_TOOLS[@]}"; do
    if command -v $tool &> /dev/null; then
        echo -e "${GREEN}✓${NC} $tool"
    else
        echo -e "${RED}✗${NC} $tool (MISSING)"
        MISSING_REQUIRED+=($tool)
    fi
done

echo ""
echo "Checking optional tools..."
for tool in "${OPTIONAL_TOOLS[@]}"; do
    if command -v $tool &> /dev/null; then
        echo -e "${GREEN}✓${NC} $tool"
    else
        echo -e "${YELLOW}○${NC} $tool (optional)"
        MISSING_OPTIONAL+=($tool)
    fi
done

echo ""
echo "========================================"
if [ ${#MISSING_REQUIRED[@]} -eq 0 ]; then
    echo -e "${GREEN}All required tools are installed!${NC}"
else
    echo -e "${RED}Missing required tools:${NC}"
    for tool in "${MISSING_REQUIRED[@]}"; do
        echo "  - $tool"
    done
    echo ""
    echo "Please install with:"
    echo "  sudo ./scripts/install/install-deps.sh"
fi

if [ ${#MISSING_OPTIONAL[@]} -gt 0 ]; then
    echo ""
    echo -e "${YELLOW}Optional tools not found (some features may not work):${NC}"
    for tool in "${MISSING_OPTIONAL[@]}"; do
        echo "  - $tool"
    done
fi

echo ""
echo "========================================"