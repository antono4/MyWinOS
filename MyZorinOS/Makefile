# MyZorinOS Makefile
# Build and install automation

.PHONY: all deps build install clean uninstall test help

# Configuration
INSTALL_PATH ?= /opt/myzorinos
BUILD_TYPE ?= full

all: deps build

deps:
	@echo "Installing dependencies..."
	@sudo ./scripts/install/install-deps.sh

build:
	@echo "Building MyZorinOS..."
	@sudo ./scripts/build/build-os.sh

install: build
	@echo "Installing to $(INSTALL_PATH)..."
	@sudo ./scripts/build/build-os.sh

clean:
	@echo "Cleaning build artifacts..."
	@rm -rf build/
	@rm -rf /tmp/myzorinos-*
	@echo "Clean complete"

uninstall:
	@echo "Uninstalling MyZorinOS..."
	@sudo rm -rf $(INSTALL_PATH)
	@rm -rf ~/.config/myzorinos
	@rm -f ~/.config/autostart/myzorinos-*.desktop
	@echo "Uninstall complete"

test:
	@echo "Running tests..."
	@./scripts/test/run-tests.sh

check:
	@echo "Checking dependencies..."
	@./scripts/check-deps.sh

config:
	@echo "Opening configuration..."
	@$(INSTALL_PATH)/bin/zorin-appearance &

restart-panel:
	@echo "Restarting panel..."
	@xfce4-panel --restart

restart-desktop:
	@echo "Restarting desktop..."
	@./scripts/config/start-desktop.sh

help:
	@echo "MyZorinOS Makefile"
	@echo ""
	@echo "Available targets:"
	@echo "  all         - Install deps and build (default)"
	@echo "  deps        - Install system dependencies"
	@echo "  build       - Build MyZorinOS"
	@echo "  install     - Build and install"
	@echo "  clean       - Remove build artifacts"
	@echo "  uninstall   - Remove MyZorinOS"
	@echo "  test        - Run tests"
	@echo "  check       - Check dependencies"
	@echo "  config      - Open configuration app"
	@echo "  restart-panel - Restart panel"
	@echo "  restart-desktop - Restart desktop"
	@echo "  help        - Show this help"