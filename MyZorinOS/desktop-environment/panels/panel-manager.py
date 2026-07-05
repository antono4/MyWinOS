#!/usr/bin/env python3
"""
MyZorinOS Panel Manager
Manages the panel (taskbar) configuration and behavior
"""

import json
import os
from pathlib import Path
from typing import Dict, List, Optional

class PanelManager:
    """Kelola konfigurasi dan perilaku panel"""
    
    def __init__(self):
        self.home = Path.home()
        self.config_dir = self.home / ".config" / "myzorinos" / "panels"
        self.config_dir.mkdir(parents=True, exist_ok=True)
        self.current_config = self.load_config()
        
    def load_config(self) -> Dict:
        """Muat konfigurasi panel"""
        config_file = self.config_dir / "panel.json"
        
        if config_file.exists():
            with open(config_file) as f:
                return json.load(f)
        
        # Default config
        return self.get_default_config()
    
    def save_config(self, config: Dict):
        """Simpan konfigurasi panel"""
        config_file = self.config_dir / "panel.json"
        with open(config_file, "w") as f:
            json.dump(config, f, indent=2)
        self.current_config = config
    
    def get_default_config(self) -> Dict:
        """Dapatkan konfigurasi default"""
        return {
            "position": "bottom",
            "height": 40,
            "autohide": False,
            "visible": True,
            "elements": {
                "start_button": {"visible": True, "icon": "start-here"},
                "launcher": {"visible": True, "items": []},
                "taskbar": {"visible": True, "grouping": "none"},
                "system_tray": {"visible": True, "items": ["network", "volume", "battery", "clock"]},
                "show_desktop": {"visible": True}
            },
            "size": {
                "icon_size": 24,
                "padding": 4
            },
            "style": {
                "background": "rgba(30, 30, 30, 0.95)",
                "blur": False,
                "shadow": True
            }
        }
    
    def get_position(self) -> str:
        """Dapatkan posisi panel"""
        return self.current_config.get("position", "bottom")
    
    def set_position(self, position: str):
        """Ubah posisi panel"""
        valid_positions = ["top", "bottom", "left", "right"]
        if position not in valid_positions:
            raise ValueError(f"Invalid position. Must be one of: {valid_positions}")
        
        self.current_config["position"] = position
        self.save_config(self.current_config)
        self.restart_panel()
    
    def get_height(self) -> int:
        """Dapatkan tinggi panel"""
        return self.current_config.get("height", 40)
    
    def set_height(self, height: int):
        """Ubah tinggi panel"""
        if height < 20 or height > 100:
            raise ValueError("Height must be between 20 and 100")
        
        self.current_config["height"] = height
        self.save_config(self.current_config)
        self.restart_panel()
    
    def is_autohide(self) -> bool:
        """Cek apakah autohide aktif"""
        return self.current_config.get("autohide", False)
    
    def set_autohide(self, enabled: bool):
        """Aktif/nonaktifkan autohide"""
        self.current_config["autohide"] = enabled
        self.save_config(self.current_config)
        self.restart_panel()
    
    def is_visible(self) -> bool:
        """Cek apakah panel visible"""
        return self.current_config.get("visible", True)
    
    def set_visible(self, visible: bool):
        """Set visibility panel"""
        self.current_config["visible"] = visible
        self.save_config(self.current_config)
    
    def get_element_config(self, element: str) -> Optional[Dict]:
        """Dapatkan konfigurasi elemen tertentu"""
        return self.current_config.get("elements", {}).get(element)
    
    def set_element_config(self, element: str, config: Dict):
        """Atur konfigurasi elemen"""
        if "elements" not in self.current_config:
            self.current_config["elements"] = {}
        
        self.current_config["elements"][element] = config
        self.save_config(self.current_config)
        self.restart_panel()
    
    def get_taskbar_items(self) -> List[Dict]:
        """Dapatkan item di taskbar"""
        taskbar_config = self.get_element_config("taskbar")
        if not taskbar_config:
            return []
        return taskbar_config.get("items", [])
    
    def add_taskbar_item(self, item: Dict):
        """Tambah item ke taskbar"""
        taskbar_config = self.get_element_config("taskbar") or {}
        items = taskbar_config.get("items", [])
        items.append(item)
        taskbar_config["items"] = items
        self.set_element_config("taskbar", taskbar_config)
    
    def remove_taskbar_item(self, item_id: str):
        """Hapus item dari taskbar"""
        taskbar_config = self.get_element_config("taskbar") or {}
        items = taskbar_config.get("items", [])
        items = [i for i in items if i.get("id") != item_id]
        taskbar_config["items"] = items
        self.set_element_config("taskbar", taskbar_config)
    
    def get_system_tray_items(self) -> List[str]:
        """Dapatkan item di system tray"""
        tray_config = self.get_element_config("system_tray")
        if not tray_config:
            return ["network", "volume", "battery", "clock"]
        return tray_config.get("items", ["network", "volume", "battery", "clock"])
    
    def set_system_tray_items(self, items: List[str]):
        """Set item system tray"""
        self.set_element_config("system_tray", {"visible": True, "items": items})
    
    def get_style(self) -> Dict:
        """Dapatkan style panel"""
        return self.current_config.get("style", {})
    
    def set_style(self, style: Dict):
        """Set style panel"""
        self.current_config["style"] = style
        self.save_config(self.current_config)
        self.restart_panel()
    
    def restart_panel(self):
        """Restart panel untuk menerapkan perubahan"""
        # Restart XFCE panel jika digunakan
        try:
            os.system("xfce4-panel --restart 2>/dev/null")
        except Exception:
            pass
    
    def generate_xfce_config(self) -> str:
        """Generate konfigurasi XFCE panel"""
        config = """[General]
Position=Bottom
Height=%d
Autohide=%s
Visible=%s

[Elements]
ShowStartButton=%s
ShowTaskbar=%s
ShowSystemTray=%s
""" % (
            self.get_height(),
            str(self.is_autohide()).lower(),
            str(self.is_visible()).lower(),
            str(self.get_element_config("start_button", {}).get("visible", True)).lower(),
            str(self.get_element_config("taskbar", {}).get("visible", True)).lower(),
            str(self.get_element_config("system_tray", {}).get("visible", True)).lower()
        )
        return config


def main():
    """Main entry point"""
    import argparse
    
    parser = argparse.ArgumentParser(description="MyZorinOS Panel Manager")
    parser.add_argument("--get-position", action="store_true")
    parser.add_argument("--set-position", choices=["top", "bottom", "left", "right"])
    parser.add_argument("--get-height", action="store_true")
    parser.add_argument("--set-height", type=int)
    parser.add_argument("--get-autohide", action="store_true")
    parser.add_argument("--toggle-autohide", action="store_true")
    parser.add_argument("--show", action="store_true")
    parser.add_argument("--hide", action="store_true")
    parser.add_argument("--restart", action="store_true")
    
    args = parser.parse_args()
    pm = PanelManager()
    
    if args.get_position:
        print(f"Position: {pm.get_position()}")
    
    if args.set_position:
        pm.set_position(args.set_position)
        print(f"Position set to: {args.set_position}")
    
    if args.get_height:
        print(f"Height: {pm.get_height()}")
    
    if args.set_height:
        pm.set_height(args.set_height)
        print(f"Height set to: {args.set_height}")
    
    if args.get_autohide:
        print(f"Autohide: {pm.is_autohide()}")
    
    if args.toggle_autohide:
        pm.set_autohide(not pm.is_autohide())
        print(f"Autohide: {pm.is_autohide()}")
    
    if args.show:
        pm.set_visible(True)
        print("Panel shown")
    
    if args.hide:
        pm.set_visible(False)
        print("Panel hidden")
    
    if args.restart:
        pm.restart_panel()
        print("Panel restarted")


if __name__ == "__main__":
    main()