#!/usr/bin/env bash

set -euxo pipefail

cd
home=$(pwd)

# Install miscellaneous packages
sudo apt install -y aircrack-ng bleachbit gparted htop macchanger netdiscover net-tools nmap ranger transmission virtualbox virtualbox-guest-additions-iso wireshark
sudo snap install --classic code
sudo snap install discord
sudo snap install spotify
sudo snap install telegram-desktop

# Install stock GNOME and reset GDM theme
sudo apt install -y gnome-session
sudo update-alternatives --config gdm3.css

# Gnome
sudo apt install -y dconf-editor gnome-tweak-tool fonts-firacode gnome-shell-extensions gnome-shell-extension-dashtodock papirus-icon-theme
sudo mkdir /usr/share/gnome-shell/extensions/inactive
sudo mv /usr/share/gnome-shell/extensions/ubuntu-dock@ubuntu.com /usr/share/gnome-shell/extensions/inactive
dconf load / < $home/configs/dconf/ubuntu

# Git
sudo apt install -y git
cp $home/configs/git/.gitconfig $home/.gitconfig

# Ssh
sudo apt install -y openssh-server
sudo systemctl disable ssh

# Terminator
sudo apt install -y terminator
mkdir $home/.config/terminator
cp $home/configs/terminator/config $home/.config/terminator/config
sudo update-alternatives --config x-terminal-emulator

# Vim
sudo apt install -y vim
cp $home/configs/vim/.vimrc $home

# Metasploit
sudo apt install -y curl
sudo sh -c "curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall && ./msfinstall"
sudo rm -f msfinstall

# Zsh
sudo apt install -y curl zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
cp $home/configs/zsh/.zshrc $home
chsh -s $(which zsh)

rm -rf $home/configs
sudo apt update -y
sudo apt dist-upgrade

history -c
reboot
