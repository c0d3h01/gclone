#!/bin/bash
set -e
set -o pipefail

# System update and base packages
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm base-devel git

# Install yay
if ! command -v yay &>/dev/null; then
    git clone https://aur.archlinux.org/yay.git
    cd yay 
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi

# Update AUR
yay -Syu --noconfirm

# Configure pacman
sudo sed -i '/\[options\]/a ParallelDownloads = 5' /etc/pacman.conf
sudo sed -i '/\[options\]/a Color' /etc/pacman.conf

# Remove conflicts and install AUR packages
yay -S --needed --noconfirm \
    brave-bin \
    zoom \
    cmake \
    android-ndk \
    openjdk-src \
    pipewire-pulse \
    pipewire-jack \
    lib32-pipewire-jack \
    alsa-plugins \
    alsa-firmware \
    sof-firmware \
    alsa-card-profiles \
    go \
    postman \
    youtube-music \
    filelight \
    firewalld \
    ananicy-cpp \
    irqbalance \
    memavaild \
    nohang \
    preload \
    prelockd \
    uresourced \
    pamac-all-git

# First remove orphaned packages if needed
sudo pacman -Rns $(pacman -Qtdq) --noconfirm

# Install all packages at once with --nodeps flag to avoid debug dependencies
yay -S --needed --noconfirm --nodeps \
    telegram-desktop \
    github-desktop \
    visual-studio-code-bin \
    ferdium-bin

# Clean up orphaned packages after all installations
sudo pacman -Rns $(pacman -Qtdq) --noconfirm 
    
# Install official packages
sudo pacman -S --needed --noconfirm \
    neovim \
    neofetch \
    htop \
    fastfetch \
    docker \
    nodejs \
    npm \
    discord \
    libreoffice \
    spectacle

# Enable services
sudo systemctl enable fstrim.timer
sudo systemctl enable docker.service

# Perf tweaks
sudo systemctl disable systemd-oomd
sudo systemctl enable ananicy-cpp
sudo systemctl enable irqbalance
sudo systemctl enable memavaild
sudo systemctl enable nohang
sudo systemctl enable preload
sudo systemctl enable prelockd
sudo systemctl enable uresourced

sed -i 's|zram_checking_enabled = False|zram_checking_enabled = True|g' /etc/nohang/nohang.conf

# Disable indexing
sudo balooctl6 disable

#Enablr bluetooth
sudo systemctl start bluetooth.service
sudo systemctl enable bluetooth.service
# Git configuration
git config --global user.name "c0d3h01"
git config --global user.email "harshalsawant2004h@gmail.com"

# Clean package cache
yay -Scc --noconfirm
sudo pacman -Scc --noconfirm