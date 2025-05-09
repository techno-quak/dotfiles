#!/bin/bash
set -e

# === Colors ===
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"

confirm() {
    read -rp "$(echo -e \"${YELLOW}→ $1 [y/N]: ${RESET}\")" response
    [[ "$response" =~ ^[Yy]$ ]]
}

step() {
    echo -e "\n${BLUE}==> $1${RESET}"
}

success() {
    echo -e "${GREEN}✔ $1${RESET}"
}

select_alternative() {
    local prompt="$1"
    shift
    local options=("$@")
    echo -e "${YELLOW}${prompt}${RESET}"
    select opt in "${options[@]}"; do
        if [[ -n "$opt" ]]; then
            echo "$opt"
            return
        else
            echo "Invalid option. Try again."
        fi
    done
}

# === Ensure yay is installed ===
if ! command -v yay &>/dev/null; then
    step "Installing yay (AUR helper)..."
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    pushd /tmp/yay && makepkg -si --noconfirm && popd
    rm -rf /tmp/yay
    success "yay installed"
fi

# === Define Packages ===

WM_PKGS=(hyprland hyprlock hypridle xdg-desktop-portal-hyprland hyprpicker swww waybar waybar-updates rofi-wayland swaync wl-clipboard cliphist swayosd-git brightnessctl udiskie devify polkit-gnome playerctl pyprland grim slurp)

CLI_PKGS=(fastfetch fzf jq eza fd vivid fish starship ripgrep bat yazi wttr wttrbar)

GUI_PKGS=(pavucontrol satty nemo zathura zathura-pdf-mupdf qimgv-light mpv easyeffects rofi-emoji)

THEME_PKGS=(catppuccin-gtk-theme-macchiato catppuccin-cursors-macchiato qt5ct qt5-wayland qt6-wayland kvantum kvantum-qt5 nwg-look)

FONT_PKGS=(ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono ttf-nerd-fonts-symbols-common ttf-font-awesome noto-fonts-cjk ttf-ms-win11-auto)

# === Alternatives ===
declare -A ALTERNATIVES
ALTERNATIVES[Browser]="zen-browser-bin firefox"
ALTERNATIVES[Email]="betterbird thunderbird"
ALTERNATIVES[Editor]="neovim vscodium"
ALTERNATIVES[Music]="spotify strawberry"

install_group() {
    local name=$1
    shift
    local packages=("$@")
    if confirm "Install: $name (${#packages[@]} packages)?"; then
        yay -S --needed --noconfirm "${packages[@]}"
        success "$name installed"
    fi
}

install_alternatives() {
    for key in "${!ALTERNATIVES[@]}"; do
        IFS=' ' read -ra options <<< "${ALTERNATIVES[$key]}"
        selected=$(select_alternative "Select $key:" "${options[@]}")
        if [[ -n "$selected" ]]; then
            yay -S --needed --noconfirm "$selected"
            success "$key ($selected) installed"
        fi
    done
}

# === Start Install ===
install_group "Wayland & Window Manager" "${WM_PKGS[@]}"
install_group "CLI / TUI Tools" "${CLI_PKGS[@]}"
install_group "Graphical Applications" "${GUI_PKGS[@]}"
install_group "Theming Packages" "${THEME_PKGS[@]}"
install_group "Fonts" "${FONT_PKGS[@]}"
install_alternatives

# === Icons ===
if confirm "Download and install Catppuccin-SE icon theme?"; then
    step "Downloading and installing icon theme..."
    mkdir -p ~/.local/share/icons
    curl -LJO https://github.com/ljmill/catppuccin-icons/releases/download/v0.2.0/Catppuccin-SE.tar.bz2
    tar -xf Catppuccin-SE.tar.bz2
    mv Catppuccin-SE ~/.local/share/icons/
    rm Catppuccin-SE.tar.bz2
    success "Icon theme installed"
fi

# === Font cache ===
if confirm "Rebuild font cache?"; then
    fc-cache -fv
    success "Font cache updated"
fi

# === Dotfiles ===
if confirm "Clone dotfiles using yadm?"; then
    read -rp "Enter your dotfiles repo URL (e.g. https://github.com/yourname/dotfiles): " REPO
    if [ -n "$REPO" ]; then
        yay -S --needed --noconfirm yadm
        yadm clone "$REPO"
        success "Dotfiles cloned"
    else
        echo "❌ Repo URL not provided. Skipping."
    fi
fi

# === Fish Configuration & Fisher Plugins ===
if confirm "Install fisher plugins and apply Catppuccin theme to Fish?"; then
    if ! command -v fish &>/dev/null; then
        echo "❌ Fish is not installed. Skipping."
    else
        if ! command -v fisher &>/dev/null; then
            step "Installing fisher..."
            fish -c 'curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher'
        fi

        fish -c "fisher list | fisher install"
        fish -c 'fish_config theme save "Catppuccin macchiato"'
        success "Fisher plugins installed and theme set"
    fi
fi

# === vivid ===
if ! yay -Q vivid &>/dev/null; then
    if confirm "Install vivid color theme tool?"; then
        yay -S --needed --noconfirm vivid
        success "vivid installed"
    fi
fi

# === ya pack ===
if command -v ya &>/dev/null; then
    if confirm "Run 'ya pack -i'?"; then 
        git clone https://github.com/DreamMaoMao/searchjump.yazi.git ~/.config/yazi/plugins/searchjump.yazi
        ya pack -i
        success "'ya pack -i' completed"
    fi
else
    echo "❌ 'ya' command not found. Skipping ya pack."
fi

success "✅ Setup complete!"

