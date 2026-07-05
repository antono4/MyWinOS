#!/usr/bin/env python3
"""
MyZorinOS Desktop Manager
Kontrol utama untuk desktop environment
"""

import os
import json
import subprocess
from pathlib import Path
from typing import Dict, List, Optional

class DesktopManager:
    """Kelas utama untuk mengelola desktop environment MyZorinOS"""
    
    def __init__(self):
        self.home = Path.home()
        self.config_dir = self.home / ".config" / "myzorinos"
        self.config_dir.mkdir(parents=True, exist_ok=True)
        self.current_layout = self._load_current_layout()
        self.panels = []
        self.widgets = []
        
    def _load_current_layout(self) -> str:
        """Muat layout yang sedang aktif"""
        layout_file = self.config_dir / "layout.json"
        if layout_file.exists():
            with open(layout_file) as f:
                data = json.load(f)
                return data.get("layout", "windows")
        return "windows"
    
    def _save_layout(self, layout: str):
        """Simpan layout yang aktif"""
        self.current_layout = layout
        layout_file = self.config_dir / "layout.json"
        with open(layout_file, "w") as f:
            json.dump({"layout": layout}, f)
    
    def get_available_layouts(self) -> List[Dict]:
        """Dapatkan semua layout yang tersedia"""
        layouts_dir = Path(__file__).parent.parent / "appearance" / "layouts"
        layouts = []
        
        for layout_file in layouts_dir.glob("*.json"):
            with open(layout_file) as f:
                layout_data = json.load(f)
                layouts.append(layout_data)
        
        return layouts
    
    def set_layout(self, layout_name: str) -> bool:
        """Ubah layout desktop"""
        valid_layouts = ["windows", "macos", "linux"]
        
        if layout_name not in valid_layouts:
            return False
        
        self._save_layout(layout_name)
        self._apply_layout(layout_name)
        return True
    
    def _apply_layout(self, layout: str):
        """Terapkan layout ke desktop"""
        layout_configs = {
            "windows": {
                "panel_position": "bottom",
                "dock_enabled": False,
                "panel_height": 40,
                "show_icons": True,
                "menu_button": "start"
            },
            "macos": {
                "panel_position": "top",
                "dock_enabled": True,
                "dock_position": "bottom",
                "panel_height": 25,
                "show_icons": True,
                "menu_button": "apple"
            },
            "linux": {
                "panel_position": "top",
                "dock_enabled": False,
                "panel_height": 32,
                "show_icons": True,
                "menu_button": "applications"
            }
        }
        
        config = layout_configs.get(layout, layout_configs["windows"])
        config_file = self.config_dir / "panel-config.json"
        
        with open(config_file, "w") as f:
            json.dump(config, f, indent=2)
        
        self._restart_panels()
    
    def _restart_panels(self):
        """Restart panel setelah perubahan layout"""
        try:
            subprocess.run(["xfce4-panel", "--restart"], 
                         capture_output=True)
        except Exception:
            pass
    
    def get_panel_config(self) -> Dict:
        """Dapatkan konfigurasi panel saat ini"""
        config_file = self.config_dir / "panel-config.json"
        
        if config_file.exists():
            with open(config_file) as f:
                return json.load(f)
        
        return {
            "panel_position": "bottom",
            "panel_height": 40,
            "dock_enabled": False
        }
    
    def list_themes(self) -> List[Dict]:
        """Daftar tema yang tersedia"""
        themes_dir = Path(__file__).parent.parent / "appearance" / "themes"
        themes = []
        
        for theme_dir in themes_dir.iterdir():
            if theme_dir.is_dir():
                theme_info = theme_dir / "theme.json"
                if theme_info.exists():
                    with open(theme_info) as f:
                        themes.append(json.load(f))
        
        return themes
    
    def set_theme(self, theme_name: str) -> bool:
        """Ubah tema desktop"""
        gtkrc = self.home / ".gtkrc-2.0"
        gtkrc_mine = self.home / ".config" / "gtk-3.0" / "settings.ini"
        
        # Write GTK theme configuration
        if gtkrc_mine.parent.exists() or True:
            gtkrc_mine.parent.mkdir(parents=True, exist_ok=True)
            with open(gtkrc_mine, "w") as f:
                f.write(f"[Settings]\n")
                f.write(f"gtk-theme-name={theme_name}\n")
        
        return True
    
    def get_wallpapers(self) -> List[Path]:
        """Dapatkan daftar wallpaper"""
        wallpapers_dir = Path(__file__).parent.parent / "appearance" / "wallpapers"
        wallpapers = []
        
        if wallpapers_dir.exists():
            for wp in wallpapers_dir.glob("*"):
                if wp.suffix.lower() in ['.png', '.jpg', '.jpeg', '.svg']:
                    wallpapers.append(wp)
        
        return wallpapers
    
    def set_wallpaper(self, wallpaper_path: str) -> bool:
        """Ubah wallpaper desktop"""
        try:
            subprocess.run([
                "xfconf-query", "-c", "xfce4-desktop",
                "-p", "/backdrop/screen0/monitor0/workspace0/last-image",
                "-s", wallpaper_path
            ], capture_output=True)
            return True
        except Exception:
            return False
    
    def enable_compositor(self) -> bool:
        """Aktifkan compositor untuk efek visual"""
        try:
            subprocess.run([
                "xfconf-query", "-c", "xfwm4",
                "-p", "/general/use_compositing",
                "-s", "true"
            ], capture_output=True)
            return True
        except Exception:
            return False
    
    def disable_compositor(self) -> bool:
        """Nonaktifkan compositor"""
        try:
            subprocess.run([
                "xfconf-query", "-c", "xfwm4",
                "-p", "/general/use_compositing",
                "-s", "false"
            ], capture_output=True)
            return True
        except Exception:
            return False


def main():
    """Main entry point untuk CLI"""
    import argparse
    
    parser = argparse.ArgumentParser(description="MyZorinOS Desktop Manager")
    parser.add_argument("--set-layout", choices=["windows", "macos", "linux"],
                       help="Ubah layout desktop")
    parser.add_argument("--get-layout", action="store_true",
                       help="Tampilkan layout saat ini")
    parser.add_argument("--list-themes", action="store_true",
                       help="Daftar tema yang tersedia")
    parser.add_argument("--set-theme", help="Ubah tema")
    parser.add_argument("--list-wallpapers", action="store_true",
                       help="Daftar wallpaper")
    parser.add_argument("--set-wallpaper", help="Ubah wallpaper")
    
    args = parser.parse_args()
    dm = DesktopManager()
    
    if args.set_layout:
        if dm.set_layout(args.set_layout):
            print(f"Layout diubah ke: {args.set_layout}")
        else:
            print("Gagal mengubah layout")
    
    if args.get_layout:
        print(f"Layout saat ini: {dm.current_layout}")
    
    if args.list_themes:
        for theme in dm.list_themes():
            print(f"- {theme.get('name', 'Unknown')}")
    
    if args.set_theme:
        if dm.set_theme(args.set_theme):
            print(f"Tema diubah ke: {args.set_theme}")
    
    if args.list_wallpapers:
        for wp in dm.get_wallpapers():
            print(f"- {wp.name}")
    
    if args.set_wallpaper:
        if dm.set_wallpaper(args.set_wallpaper):
            print(f"Wallpaper diubah")
    
    if not any(vars(args).values()):
        parser.print_help()


if __name__ == "__main__":
    main()