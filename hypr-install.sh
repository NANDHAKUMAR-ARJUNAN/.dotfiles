#!/usr/bin/bash
# Automatic hyprland installation on Arch based distro's
# -------------------------------------------
# 1 . Root Check
# -------------------------------------------
if [[ $EUID -ne 0]]; then
  echo "Please run as root (use sudo)"
  exit 1
fi
# update the system
pacman -Syu --noconfirm \
  plasma kde-applications sddm \
  hyprland rofi waybar swww dunst neovim \
  hyprlock hypridle \
  yazi dunst tmux zoxide bat eza fzf fd ripgrep cliphist wl-copy 
#enables sddm display manager 
systemctl enable sddm.service
# installing AUR helper yay !
if ! command -v yay &> /dev/null; then
  sudo -u $SUDO_USER bash <<EOF
    cd $HOME
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm 
EOF
fi

#enable essential services !
sudo -u "SUDO_USER" systemctl --user enable pipewire.service pipewire-pulse.service wireplumber.service
systemctl enable seatd.service

# config directories 
# echo "🗂 Setting up config files..."
USER_HOME=$(eval echo ~${SUDO_USER})
# If you have dotfiles in GitHub, clone them
if [[ ! -d "$USER_HOME/.dotfiles" ]]; then
  echo " Cloning your dotfiles"
  sudo -u $SUDO_USER git clone https://github.com/NANDHAKUMAR-ARJUNAN/.dotfiles.git "$USER_HOME/.dotfiles"
  # Copy configs
  cp -r "$USER_HOME/.dotfiles/hypr" "$USER_HOME/.config/"
  cp -r "$USER_HOME/.dotfiles/waybar" "$USER_HOME/.config/"
  cp -r "$USER_HOME/.dotfiles/rofi" "$USER_HOME/.config/"
  cp -r "$USER_HOME/.dotfiles/zsh" "$USER_HOME/.config/"
  cp -r "$USER_HOME/.dotfiles/kitty" "$USER_HOME/.config/"
  cp -r "$USER_HOME/.dotfiles/swww" "$USER_HOME/.config/"


fi
sh -c "$(curl -fsSL https://raw.githubusercontent.com/keyitdev/sddm-astronaut-theme/master/setup.sh)"

echo "Installation finished successfully !"


 
