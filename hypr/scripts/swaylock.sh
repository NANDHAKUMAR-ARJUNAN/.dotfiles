swayidle -w timeout 180 'swaylock -C $HOME/.config/sway_lock/config -f' timeout 240 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'
