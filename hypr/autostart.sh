#!/usr/bin/env bash
# Hyprland autostart script

# Config directory
DIR="$HOME/.config/hypr"

# -------------------------------
# Wallpapers
# Start swww daemon and set wallpaper
swww-daemon &
swww img "$HOME/.config/swww/wall.jpg" --transition-type grow --resize fill &

# -------------------------------
# Notifications
dunst &
"$DIR/scripts/dunst/battery_loop.sh" &
"$DIR/scripts/dunst/dummy.sh" &

# -------------------------------
# Waybar (optional)
# waybar --config "$HOME/.config/waybar/bak/config.jsonc" -s "$HOME/.config/waybar/bak/style.css" &

# -------------------------------
# Hyprland idle daemon
hypridle &

# -------------------------------
# Cursor & GTK settings
hyprctl setcursor 'Bibata-Modern-Ice' 28
gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Ice"
gsettings set org.gnome.desktop.interface cursor-size 28
gsettings set org.gnome.desktop.interface icon-theme "WhiteSur-dark"
gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-Dark"

# -------------------------------
# Clipboard monitoring
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &

# -------------------------------
# VirtualBox VM example (optional)
# VBoxManage startvm fedora-vm-1 --type headless &
