#!/bin/bash

sudo pacman -Syu yay

YAY="yay -Sy --noconfirm --sudoloop --needed"

WORK="zen-browser"
COMMS="betterbird vesktop"
DEV="neovim yadm"
UTILS="hyprfreeze topgrade fastfetch nvtop btop fzf ripgrep fd satty"
ENT="spotify freetube mangohud"

#Install hyprland with basic components
HYPR="hyprland uwsm xdg-desktop-portal-hyprland hyprpolkitagent"
$YAY $HYPR

#Install other things for hyprland
HYPRADD="hyprlock hypridle hyprpicker swww rofi-wayland wl-clipboard cliphist swayosd brightnessctl pyprland"
$YAY $HYPRADD

#Install waybar and components
BAR="waybar waybar-updates wttr wttrbar cava"
$YAY $BAR

#Install greeter
GREET="greetd greetd-regreet"
$YAY $GREET
sudo systemctl enable greetd.service

#Color theme
THEME="catppuccin-gtk-theme-macchiato catppuccin-cursors-macchiato qt5ct qt5-wayland qt6-wayland kvantum kvantum-qt5 nwg-look"
$YAY $THEME

#Icon theme
curl -LJO https://github.com/ljmill/catppuccin-icons/releases/download/v0.2.0/Catppuccin-SE.tar.bz2
tar -xf Catppuccin-SE.tar.bz2
mv Catppuccin-SE ~/.local/share/icons/
rm Catppuccin-SE.tar.bz2

#Fonts
FONTS="ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono ttf-nerd-fonts-symbols-common ttf-font-awesome noto-fonts-cjk ttf-ms-win11-auto"
$YAY $FONTS
fc-cache -fv

#Bluetooth
BLUETOOTH="overskride"
$YAY $BLUETOOTH
sudo systemctl enable --now bluetooth

#Internet
INTERNET="nm-connection-editor iwgtk"
$YAY $INTERNET

#Sound
SOUND="playerctl pavucontrol easyeffects"
$YAY $SOUND

#Terminal
TERMINAL="kitty starship fish fisher vivid"
$YAY $TERMINAL
fisher list | fisher install
fish_config theme save "Catppuccin Macchiato"

#Multimedia
FILES="yazi nautilus bat udiskie"
$YAY $FILES

#Install yazi plugins
ya pack -i
git clone https://github.com/DreamMaoMao/searchjump.yazi.git ~/.config/yazi/plugins/searchjump.yazi
git clone https://github.com/DreamMaoMao/fg.yazi.git ~/.config/yazi/plugins/fg.yazi
git clone https://gitee.com/DreamMaoMao/fg.yazi.git $env:APPDATA\yazi\config\plugins\fg.yazi

#Bat theme
mkdir -p "$(bat --config-dir)/themes"
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme
bat cache --build

#Notifications
NOTIFY="devify swaync"
$YAY $NOTIFY

#Install dotfiles
yadm clone https://github.com/techno-quak/dotfiles.git
