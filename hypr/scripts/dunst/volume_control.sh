#!/usr/bin/env bash

DIR="$HOME/.config/hypr"
USER_NAME="$USER"
HOST_NAME="$(hostname)"
DATE_STR="$(date '+%Y-%m-%d')"
ICON_DIR="$DIR/scripts/dunst/assets"

# Check mute status
IS_MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q '\[MUTED\]' && echo "yes" || echo "no")

case "$1" in
high)
  if [[ $IS_MUTED == "no" ]]; then
    wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+
    VOLUME="Volume $(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}')%"
    ICON="$ICON_DIR/audio-round-svgrepo-com.svg"
  else
    VOLUME="MUTED"
    ICON="$ICON_DIR/audio-mute-round-svgrepo-com.svg"
  fi
  ;;
low)
  if [[ $IS_MUTED == "no" ]]; then
    wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-
    VOLUME="Volume $(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}')%"
    ICON="$ICON_DIR/audio-round-svgrepo-com.svg"
  else
    VOLUME="MUTED"
    ICON="$ICON_DIR/audio-mute-round-svgrepo-com.svg"
  fi
  ;;
mute)
  wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
  IS_MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q '\[MUTED\]' && echo "yes" || echo "no")

  if [[ $IS_MUTED == "yes" ]]; then
    VOLUME="MUTED"
    ICON="$ICON_DIR/audio-mute-round-svgrepo-com.svg"
  else
    VOLUME="UNMUTED"
    ICON="$ICON_DIR/audio-high-round-svgrepo-com.svg"
  fi
  ;;
*)
  echo "Usage: $0 {high|low|mute}"
  exit 1
  ;;
esac

# # Notification
# dunstify -u low \
#   -i "$ICON" \
#   -h string:x-dunst-stack-tag:volume \
#   "$VOLUME"
#
dunstify -u low \
  -i $ICON \
  -h string:x-dunst-stack-tag:custominfo \
  " " \
  "<span font='JetBrainsMono Nerd Font 16' color='#e0af68'> <b><span color='#a9b1d6'>$VOLUME</span></b></span>\n\n<span font='JetBrainsMono Nerd Font 12' color='#f7768e'> : <b><span color='#a9b1d6'>$USER_NAME</span></b></span>  <span font='JetBrainsMono Nerd Font 12'color='#7aa2f7' >󰒋 :<b><span color='#a9b1d6'>$HOST_NAME</span></b></span>  <span font='JetBrainsMono Nerd Font 12'color='#ff9e64' >󰃰 :<b><span color='#a9b1d6'>$DATE_STR</span></b></span>"
