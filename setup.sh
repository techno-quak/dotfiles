#!/bin/bash

MINIMAL="hyprland pyprland hyprlock hypridle xdg-desktop-portal-hyprland hyprpicker swww waybar rofi-wayland swaync wl-clipboard cliphist swayosd-git brightnessctl udiskie devify polkit-gnome playerctl pyprland grim slurp greetd greetd-tuigreet systemd satty yadm zathura zathura-pdf-mupdf qimgv-light mpv"
AUDIO="pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber alsa-utils pavucontrol"
SHELLUTILS="fastfetch fzf jq eza fd vivid fish starship ripgrep bat"
FILES="yazi syncthing nautilus"
THEME="atppuccin-gtk-theme-macchiato catppuccin-cursors-macchiato qt5ct qt5-wayland qt6-wayland kvantum kvantum-qt5 nwg-look ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono ttf-nerd-fonts-symbols-common ttf-font-awesome noto-fonts-cjk ttf-ms-win11-auto"
COMMUNICATION="vesktop betterbird"
DEV="vscodium"
ENT="spotify freetube"
security="ufw keepassxc"

#Minimal install
sudo pacman --needed -Syu yay
yay -Syu --sudoloop --noconfirm --needed $MINIMAL

#Audio
read -p "Install audio pack (y/n)?" choice
case "$choice" in
y | Y)
  yay -S --noconfirm --needed $AUDIO
  systemctl --user enable --now pipewire wireplumber
  systemctl enable greetd.service
  ;;
n | N) echo "" ;;
*) echo "invalid" ;;
esac

#Icons
read -p "Install icons (y/n)?" choice
case "$choice" in
y | Y)
  curl -LJO https://github.com/ljmill/catppuccin-icons/releases/download/v0.2.0/Catppuccin-SE.tar.bz2
  tar -xf Catppuccin-SE.tar.bz2
  mv Catppuccin-SE ~/.local/share/icons/
  ;;
n | N) echo "" ;;
*) echo "invalid" ;;
esac

#Theme
fc-cache -fv

