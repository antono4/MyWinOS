#!/usr/bin/env python3
"""
MyZorinOS Zorin Appearance
Aplikasi utama untuk mengkustomisasi tampilan desktop
"""

import gi
gi.require_version('Gtk', '4.0')
gi.require_version('Adw', '1')

from gi.repository import Gtk, Adw, Gdk, Gio
import os
import json
from pathlib import Path

class ZorinAppearanceWindow(Adw.ApplicationWindow):
    """Jendela utama Zorin Appearance"""
    
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.set_title("Zorin Appearance")
        self.set_default_size(900, 650)
        self.set_size_request(800, 550)
        
        # Load CSS
        self.setup_css()
        
        # Build UI
        self.setup_ui()
        
    def setup_css(self):
        """Setup custom CSS styling"""
        css_provider = Gtk.CssProvider()
        css = """
        .appearance-window {
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
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 20px;
        }
        .card {
            background: #2a2a2a;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 16px;
        }
        .card-title {
            color: #ffffff;
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 12px;
        }
        .layout-grid {
            display: flex;
            gap: 16px;
            flex-wrap: wrap;
        }
        .layout-option {
            background: #333333;
            border-radius: 12px;
            padding: 16px;
            border: 3px solid transparent;
            cursor: pointer;
            width: 140px;
            text-align: center;
        }
        .layout-option:hover {
            border-color: #7c4dff;
        }
        .layout-option.selected {
            border-color: #7c4dff;
            background: #3a3a3a;
        }
        .layout-icon {
            font-size: 48px;
            margin-bottom: 8px;
        }
        .layout-name {
            color: #ffffff;
            font-size: 14px;
            font-weight: 600;
        }
        .color-button {
            width: 48px;
            height: 48px;
            border-radius: 24px;
            border: 3px solid transparent;
            cursor: pointer;
        }
        .color-button:hover {
            border-color: #ffffff;
        }
        .color-button.selected {
            border-color: #7c4dff;
        }
        .theme-preview {
            width: 80px;
            height: 50px;
            border-radius: 8px;
            margin: 8px;
            cursor: pointer;
            border: 3px solid transparent;
        }
        .theme-preview:hover {
            border-color: #7c4dff;
        }
        .theme-preview.selected {
            border-color: #7c4dff;
        }
        .wallpaper-preview {
            width: 160px;
            height: 100px;
            border-radius: 8px;
            margin: 8px;
            cursor: pointer;
            background-size: cover;
            background-position: center;
            border: 3px solid transparent;
        }
        .wallpaper-preview:hover {
            border-color: #7c4dff;
        }
        .wallpaper-preview.selected {
            border-color: #7c4dff;
        }
        .switch-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #3a3a3a;
        }
        .switch-label {
            color: #ffffff;
            font-size: 14px;
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
        main_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=0)
        self.set_child(main_box)
        
        # Sidebar
        sidebar = self.create_sidebar()
        main_box.append(sidebar)
        
        # Content area
        self.content_stack = Gtk.Stack()
        self.content_stack.set_transition_type(Gtk.StackTransitionType.SLIDE_LEFT_RIGHT)
        main_box.append(self.content_stack)
        
        # Create pages
        self.create_layout_page()
        self.create_look_page()
        self.create_background_page()
        self.create_fonts_page()
        self.create_about_page()
        
        # Set default page
        self.content_stack.set_visible_child_name("layout")
        self.active_button = self.layout_button
    
    def create_sidebar(self):
        """Buat sidebar dengan navigasi"""
        sidebar = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=8)
        sidebar.set_size_request(220, -1)
        sidebar.add_css_class("sidebar")
        
        # Header
        header = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=12)
        header.set_margin_top(16)
        header.set_margin_bottom(24)
        header.set_margin_start(16)
        header.set_margin_end(16)
        
        icon = Gtk.Image.new_from_icon_name("preferences-desktop-theme")
        icon.set_pixel_size(32)
        header.append(icon)
        
        title_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)
        title = Gtk.Label(label="<b>Zorin Appearance</b>")
        title.set_use_markup(True)
        title.set_halign(Gtk.Align.START)
        title_box.append(title)
        subtitle = Gtk.Label(label="Customize your desktop")
        subtitle.set_halign(Gtk.Align.START)
        subtitle.add_css_class("dim-label")
        title_box.append(subtitle)
        header.append(title_box)
        sidebar.append(header)
        
        # Navigation buttons
        self.layout_button = self.create_nav_button(
            "Layout", "view-grid-symbolic", "layout")
        self.look_button = self.create_nav_button(
            "Look", "applications-graphics-symbolic", "look")
        self.background_button = self.create_nav_button(
            "Background", "preferences-desktop-wallpaper-symbolic", "background")
        self.fonts_button = self.create_nav_button(
            "Fonts", "preferences-desktop-font-symbolic", "fonts")
        self.about_button = self.create_nav_button(
            "About", "dialog-information-symbolic", "about")
        
        # Add separator
        separator = Gtk.Separator(orientation=Gtk.Orientation.HORIZONTAL)
        separator.set_margin_vertical(12)
        sidebar.append(separator)
        
        # Reset button
        reset_btn = Gtk.Button(label="Reset to Defaults")
        reset_btn.set_margin_start(16)
        reset_btn.set_margin_end(16)
        sidebar.append(reset_btn)
        
        return sidebar
    
    def create_nav_button(self, label, icon_name, page_name):
        """Buat tombol navigasi"""
        btn = Gtk.Button()
        btn.add_css_class("sidebar-button")
        
        box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=12)
        icon = Gtk.Image.new_from_icon_name(icon_name)
        icon.set_pixel_size(24)
        box.append(icon)
        
        text = Gtk.Label(label=label)
        text.set_halign(Gtk.Align.START)
        box.append(text)
        
        btn.set_child(box)
        btn.connect("clicked", self.on_nav_click, page_name)
        
        # Store reference
        self.content_stack.append(Gtk.Box())  # Placeholder
        
        return btn
    
    def on_nav_click(self, button, page_name):
        """Handler navigasi"""
        if hasattr(self, 'active_button'):
            self.active_button.remove_css_class("active")
        button.add_css_class("active")
        self.active_button = button
        self.content_stack.set_visible_child_name(page_name)
    
    def create_layout_page(self):
        """Buat halaman Layout"""
        page = Gtk.ScrolledWindow()
        page.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)
        page.add_css_class("content-area")
        
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=16)
        box.set_margin_start(24)
        box.set_margin_end(24)
        box.set_margin_top(24)
        box.set_margin_bottom(24)
        page.set_child(box)
        
        # Title
        title = Gtk.Label(label="Desktop Layout")
        title.add_css_class("section-title")
        title.set_halign(Gtk.Align.START)
        box.append(title)
        
        # Description
        desc = Gtk.Label(
            label="Change the layout of your desktop to make it feel familiar,\n"
                  "whether it's Windows, macOS, or traditional Linux.")
        desc.set_halign(Gtk.Align.START)
        desc.set_lines(2)
        box.append(desc)
        
        # Layout options
        layout_grid = Gtk.Grid()
        layout_grid.set_row_spacing(16)
        layout_grid.set_column_spacing(16)
        layout_grid.set_margin_top(24)
        
        layouts = [
            ("windows", "🪟", "Windows"),
            ("macos", "🍎", "macOS"),
            ("linux", "🐧", "Traditional Linux")
        ]
        
        self.selected_layout = "windows"
        
        for i, (layout_id, icon, name) in enumerate(layouts):
            card = self.create_layout_card(layout_id, icon, name)
            layout_grid.attach(card, i, 0, 1, 1)
        
        box.append(layout_grid)
        
        # Additional options
        options_card = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        options_card.add_css_class("card")
        
        options_title = Gtk.Label(label="Panel Options")
        options_title.add_css_class("card-title")
        options_title.set_halign(Gtk.Align.START)
        options_card.append(options_title)
        
        # Auto-hide panel
        switch_row = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL)
        switch_row.set_margin_top(12)
        switch_label = Gtk.Label(label="Auto-hide panel")
        switch_label.set_hexpand(True)
        switch_row.append(switch_label)
        
        switch = Gtk.Switch()
        switch_row.append(switch)
        options_card.append(switch_row)
        
        # Show icons
        switch_row2 = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL)
        switch_row2.set_margin_top(12)
        switch_label2 = Gtk.Label(label="Show desktop icons")
        switch_label2.set_hexpand(True)
        switch_row2.append(switch_label2)
        
        switch2 = Gtk.Switch()
        switch2.set_active(True)
        switch_row2.append(switch2)
        options_card.append(switch_row2)
        
        box.append(options_card)
        
        self.content_stack.add_named(page, "layout")
    
    def create_layout_card(self, layout_id, icon, name):
        """Buat card untuk pilihan layout"""
        card = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=8)
        card.add_css_class("layout-option")
        card.set_valign(Gtk.Align.START)
        
        icon_label = Gtk.Label(label=icon)
        icon_label.add_css_class("layout-icon")
        card.append(icon_label)
        
        name_label = Gtk.Label(label=name)
        name_label.add_css_class("layout-name")
        card.append(name_label)
        
        # Click handler
        card.set_cursor(Gdk.Cursor.new_from_name("pointer"))
        card.connect("clicked", self.on_layout_select, layout_id)
        
        return card
    
    def on_layout_select(self, widget, layout_id):
        """Handler pemilihan layout"""
        self.selected_layout = layout_id
        print(f"Layout selected: {layout_id}")
        # Update UI untuk menunjukkan pilihan
        # Update semua layout card untuk remove selected class
        # dan tambahkan ke yang dipilih
    
    def create_look_page(self):
        """Buat halaman Look"""
        page = Gtk.ScrolledWindow()
        page.set_policy(Gtk.Pri