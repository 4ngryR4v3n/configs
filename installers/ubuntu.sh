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
sudo apt install -y aircrack-ng bleachbit gparted htop macchanger netdiscover net-tools nmap ranger transmission virtualbox virtualbox-guest-additions-iso wireshark
sudo snap install --classic code
sudo snap install discord
sudo snap install spotify
sudo snap install telegram-desktop

# Install stock GNOME and reset GDM theme
sudo apt install -y gnome-session
sudo update-alternatives --config gdm3.css

# Git
sudo apt install -y git
if [ -d $cfgdir ]; then
    echo "$cfgdir already exists."
else
    git clone https://github.com/Perdyx/configs $cfgdir
fi
cp $home/$cfgdir/configs/git/.gitconfig $home/.gitconfig

# Config backup service
sudo chmod +x $home/$cfgdir/services/cfgbackup.sh
sed -i "s/USER/$user/g" $home/$cfgdir/services/cfgbackup.service
sudo cp $home/$cfgdir/services/cfgbackup.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable cfgbackup.service

# Gnome
sudo apt install -y dconf-editor gnome-tweak-tool fonts-firacode gnome-shell-extensions gnome-shell-extension-dashtodock papirus-icon-theme
sudo mkdir /usr/share/gnome-shell/extensions/inactive
sudo mv /usr/share/gnome-shell/extensions/ubuntu-dock@ubuntu.com /usr/share/gnome-shell/extensions/inactive
dconf load / < $home/$cfgdir/configs/dconf/Ubuntu

# Terminator
sudo apt install -y terminator
mkdir $home/.config/terminator
cp $home/$cfgdir/configs/terminator/config $home/.config/terminator/config
sudo update-alternatives --config x-terminal-emulator

# Vim
sudo apt install -y vim
cp $home/$cfgdir/configs/vim/.vimrc $home

# Ssh
sudo apt install -y openssh-server
sudo systemctl disable ssh

# Macros
sudo apt install -y xbindkeys xdotool
cp $home/$cfgdir/configs/xbindkeys/.xbindkeysrc $home

# Metasploit
sudo apt install -y curl
sudo sh -c "curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall && ./msfinstall"
sudo rm -f msfinstall

# Zsh
sudo apt install -y curl zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
cp $home/$cfgdir/configs/zsh/.zshrc $home
chsh -s $(which zsh)

sudo apt update -y
sudo apt dist-upgrade

history -c
reboot
