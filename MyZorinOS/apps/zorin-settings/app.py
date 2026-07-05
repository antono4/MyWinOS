#!/usr/bin/env python3
"""
MyZorinOS Zorin Settings
Aplikasi pengaturan sistem untuk MyZorinOS
"""

import gi
gi.require_version('Gtk', '4.0')
gi.require_version('Adw', '1')

from gi.repository import Gtk, Adw, Gdk, Gio
import subprocess
import os

class ZorinSettingsWindow(Adw.ApplicationWindow):
    """Jendela utama Zorin Settings"""
    
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.set_title("Settings")
        self.set_default_size(800, 600)
        
        self.setup_ui()
        
    def setup_css(self):
        """Setup custom CSS styling"""
        css_provider = Gtk.CssProvider()
        css = """
        .settings-window {
            background: #1e1e1e;
        }
        .sidebar {
            background: #252525;
            padding: 10px;
        }
        .sidebar-button {
            margin: 4px 0;
            padding: 12px 16px;
            border-radius: 8px;
            background: transparent;
            color: #ffffff;
            border: none;
            text-align: left;
            font-size: 14px;
        }
        .sidebar-button:hover {
            background: #3a3a3a;
        }
        .sidebar-button.active {
            background: #7c4dff;
        }
        .content-area {
            background: #1e1e1e;
            padding: 24px;
        }
        .section-title {
            color: #ffffff;
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 16px;
        }
        .settings-card {
            background: #2a2a2a;
            border-radius: 12px;
            padding: 16px;
            margin-bottom: 16px;
        }
        .setting-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #3a3a3a;
        }
        .setting-row:last-child {
            border-bottom: none;
        }
        .setting-label {
            color: #ffffff;
            font-size: 14px;
        }
        .setting-desc {
            color: #b3b3b3;
            font-size: 12px;
            margin-top: 4px;
        }
        """
        css_provider.load_from_string(css)
        Gtk.StyleContext.add_provider_for_display(
            Gdk.Display.get_default(),
            css_provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        )
    
    def setup_ui(self):
        """Setup antarmuka pengguna"""
        self.setup_css()
        
        main_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=0)
        self.set_child(main_box)
        
        # Sidebar
        sidebar = self.create_sidebar()
        main_box.append(sidebar)
        
        # Content
        self.content_view = self.create_content_view()
        main_box.append(self.content_view)
        
    def create_sidebar(self):
        """Buat sidebar"""
        sidebar = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=8)
        sidebar.set_size_request(240, -1)
        sidebar.add_css_class("sidebar")
        
        # Search
        search_entry = Gtk.SearchEntry()
        search_entry.set_placeholder_text("Search settings...")
        search_entry.set_margin_start(12)
        search_entry.set_margin_end(12)
        search_entry.set_margin_top(12)
        search_entry.set_margin_bottom(12)
        sidebar.append(search_entry)
        
        # Separator
        sep = Gtk.Separator(orientation=Gtk.Orientation.HORIZONTAL)
        sep.set_margin_vertical(8)
        sidebar.append(sep)
        
        # Navigation items
        items = [
            ("Network", "network-wireless-symbolic"),
            ("Bluetooth", "bluetooth-symbolic"),
            ("Display", "video-display-symbolic"),
            ("Sound", "audio-volume-high-symbolic"),
            ("Power", "battery-symbolic"),
            ("Printers", "printer-symbolic"),
            ("Mouse & Touchpad", "input-mouse-symbolic"),
            ("Keyboard", "input-keyboard-symbolic"),
            ("Region & Language", "preferences-desktop-locale-symbolic"),
            ("Accessibility", "accessibility-symbolic"),
            ("Privacy", "security-high-symbolic"),
            ("Date & Time", "clock-symbolic"),
            ("Software", "software-symbolic"),
            ("About", "dialog-information-symbolic"),
        ]
        
        for label, icon_name in items:
            btn = Gtk.Button()
            btn.add_css_class("sidebar-button")
            
            box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=12)
            icon = Gtk.Image.new_from_icon_name(icon_name)
            icon.set_pixel_size(20)
            box.append(icon)
            
            text = Gtk.Label(label=label)
            text.set_halign(Gtk.Align.START)
            box.append(text)
            
            btn.set_child(box)
            sidebar.append(btn)
        
        return sidebar
    
    def create_content_view(self):
        """Buat area konten"""
        scrolled = Gtk.ScrolledWindow()
        scrolled.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)
        scrolled.add_css_class("content-area")
        
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=16)
        box.set_margin_start(24)
        box.set_margin_end(24)
        box.set_margin_top(24)
        box.set_margin_bottom(24)
        
        # Title
        title = Gtk.Label(label="Network")
        title.add_css_class("section-title")
        title.set_halign(Gtk.Align.START)
        box.append(title)
        
        # Network Settings Card
        network_card = self.create_network_card()
        box.append(network_card)
        
        # Bluetooth Card
        bluetooth_card = self.create_bluetooth_card()
        box.append(bluetooth_card)
        
        scrolled.set_child(box)
        return scrolled
    
    def create_network_card(self):
        """Buat card pengaturan network"""
        card = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        card.add_css_class("settings-card")
        
        # WiFi
        wifi_row = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL)
        wifi_label_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=2)
        
        wifi_icon = Gtk.Image.new_from_icon_name("network-wireless-symbolic")
        wifi_icon.set_pixel_size(24)
        wifi_label_box.append(wifi_icon)
        
        label_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=2)
        label_box.append(Gtk.Label(label="Wi-Fi"))
        label_box.append(Gtk.Label(label="Connect to wireless networks"))
        label_box.set_halign(Gtk.Align.START)
        
        wifi_row.append(wifi_icon)
        wifi_row.append(label_box)
        
        wifi_switch = Gtk.Switch()
        wifi_switch.set_active(True)
        wifi_row.append(wifi_switch)
        
        card.append(wifi_row)
        
        # VPN
        vpn_row = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL)
        vpn_label_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=2)
        
        vpn_icon = Gtk.Image.new_from_icon_name("network-vpn-symbolic")
        vpn_icon.set_pixel_size(24)
        
        label_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=2)
        label_box.append(Gtk.Label(label="VPN"))
        label_box.append(Gtk.Label(label="Virtual Private Network"))
        label_box.set_halign(Gtk.Align.START)
        
        vpn_row.append(vpn_icon)
        vpn_row.append(label_box)
        
        vpn_switch = Gtk.Switch()
        vpn_row.append(vpn_switch)
        
        card.append(vpn_row)
        
        return card
    
    def create_bluetooth_card(self):
        """Buat card pengaturan bluetooth"""
        card = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        card.add_css_class("settings-card")
        
        # Bluetooth
        bt_row = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL)
        bt_label_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=2)
        
        bt_icon = Gtk.Image.new_from_icon_name("bluetooth-active-symbolic")
        bt_icon.set_pixel_size(24)
        
        label_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=2)
        label_box.append(Gtk.Label(label="Bluetooth"))
        label_box.append(Gtk.Label(label="Off"))
        label_box.set_halign(Gtk.Align.START)
        
        bt_row.append(bt_icon)
        bt_row.append(label_box)
        
        bt_switch = Gtk.Switch()
        bt_row.append(bt_switch)
        
        card.append(bt_row)
        
        return card


class ZorinSettingsApp(Adw.Application):
    """Aplikasi utama Zorin Settings"""
    
    def __init__(self):
        super().__init__(application_id='com.myzorinos.settings',
                        flags=Gio.ApplicationFlags.FLAGS_NONE)
        self.connect('activate', self.on_activate)
    
    def on_activate(self, app):
        win = ZorinSettingsWindow(application=app)
        win.present()


def main():
    app = ZorinSettingsApp()
    app.run(None)


if __name__ == "__main__":
    main()