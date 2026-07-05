#!/bin/bash
# MyZorinOS Session Configuration for LightDM
# Place this file in /usr/share/lightdm/lightdm.conf.d/

[Seat:*]
user-session=myzorinos
session-wrapper=/usr/share/xsessions/myzorinos.desktop

# Or for LightDM config:
# Type this in terminal:
# sudo cp scripts/config/lightdm.conf /etc/lightdm/lightdm.conf.d/50-myzorinos.conf