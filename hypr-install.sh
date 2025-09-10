#!/usr/bin/bash
# Automatic hyprland installation on Arch based distro's
# -------------------------------------------
# 1 . Root Check
# -------------------------------------------
#if [[ $EUID -ne 0 ]]; then
#  echo "Please run as root (use sudo)"
#  exit 1
#fi

if ! command -v yay &>/dev/null; then
  sudo -u $SUDO_USER bash <<EOF
    cd $HOME
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm 
EOF
fi

# update the system
yay -Syu --noconfirm \
  plasma kde-applications sddm \
  hyprland rofi waybar swww dunst kitty \
  hyprlock hypridle \
  yazi dunst tmux zoxide bat eza fzf fd ripgrep cliphist wl-clipboard \
  wget vim git

# installing whitsur gtk icon themes !
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git
./install.sh
echo "Installing starship prompt"
curl -sS https://starship.rs/install.sh | sh

#enables sddm display manager
systemctl enable sddm.service

#enable essential services !
sudo -u "SUDO_USER" systemctl --user enable pipewire.service pipewire-pulse.service wireplumber.service
systemctl enable seatd.service

# config directories
# echo "🗂 Setting up config files..."
#HOME=$(eval echo ~${SUDO_USER})
# If you have dotfiles in GitHub, clone them
if [[ ! -d "$HOME/.dotfiles" ]]; then
  echo " Cloning your dotfiles"
  git clone https://github.com/NANDHAKUMAR-ARJUNAN/.dotfiles.git "$HOME/.dotfiles"
  # Copy configs
  cp -r "$HOME/.dotfiles/hypr" "$HOME/.config/"
  cp -r "$HOME/.dotfiles/waybar" "$HOME/.config/"
  cp -r "$HOME/.dotfiles/rofi" "$HOME/.config/"
  cp -r "$HOME/.dotfiles/kitty" "$HOME/.config/"
  cp -r "$HOME/.dotfiles/swww" "$HOME/.config/"
  cp -r "$HOME/.dotfiles/zsh/.zshrc" "$HOME"
  cp -r "$HOME/.dotfiles/zsh/starship.toml" "$HOME/.config/"
fi
sh -c "$(curl -fsSL https://raw.githubusercontent.com/keyitdev/sddm-astronaut-theme/master/setup.sh)"

echo "changing shell for user"
chsh -s /usr/bin/zsh

echo "Installation finished successfully !"
read -p "Reboot required after installation [y/n]: " value
if [[ "$value" == "y" ]]; then
  sudo reboot
else
  exit 1
fi
