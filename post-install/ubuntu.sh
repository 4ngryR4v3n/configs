#!/usr/bin/env bash

set -euxo pipefail

cd

user=$(whoami)

if [ "$EUID" -ne 0 ]; then
    sudo echo
fi

home=$(cd && pwd)
cfgdir=".cfg"

# Install miscellaneous packages
sudo apt install -y aircrack-ng bleachbit gparted htop macchanger netdiscover net-tools nmap terminator transmission vim virtualbox virtualbox-guest-additions-iso wireshark xbindkeys xdotool
sudo snap install --classic code
sudo snap install discord
sudo snap install spotify
sudo snap install telegram-desktop

# Git
sudo apt install -y git
if [ -d $cfgdir ]; then
    echo "$cfgdir already exists."
else
    git clone https://github.com/Perdyx/configs $cfgdir
fi
cp $home/$cfgdir/configs/git/.gitconfig $home/.gitconfig

# Install and set up GNOME
sudo apt install -y dconf-editor gnome-session gnome-tweak-tool fonts-firacode gnome-shell-extensions gnome-shell-extension-dashtodock papirus-icon-theme
sudo update-alternatives --config gdm3.css
sudo mkdir /usr/share/gnome-shell/extensions/inactive
sudo mv /usr/share/gnome-shell/extensions/ubuntu-dock@ubuntu.com /usr/share/gnome-shell/extensions/inactive

# Set up configs
mkdir $home/.config/terminator
cp $home/$cfgdir/configs/terminator/config $home/.config/terminator/config
sudo update-alternatives --config x-terminal-emulator
cp $home/$cfgdir/configs/vim/.vimrc $home
cp $home/$cfgdir/configs/xbindkeys/.xbindkeysrc $home

# Ssh
sudo apt install -y openssh-server
sudo systemctl disable ssh

# Zsh
sudo apt install -y curl zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
cp $home/$cfgdir/configs/zsh/.zshrc $home
chsh -s $(which zsh)

sudo apt update -y
sudo apt dist-upgrade

history -c
reboot
