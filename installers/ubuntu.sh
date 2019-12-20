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

# Git
sudo apt install -y git
cp $home/configs/git/.gitconfig $home/.gitconfig

# GNOME
sudo apt install -y gnome-tweak-tool fonts-firacode gnome-shell-extensions gnome-shell-extension-dashtodock papirus-icon-theme
sudo mkdir /usr/share/gnome-shell/extensions/inactive
sudo mv /usr/share/gnome-shell/extensions/ubuntu-dock@ubuntu.com /usr/share/gnome-shell/extensions/inactive

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

# Base16 - Gnome Terminal color scheme install script
[[ -z "$PROFILE_NAME" ]] && PROFILE_NAME="terminal.sexy"
[[ -z "$PROFILE_SLUG" ]] && PROFILE_SLUG="terminal-dot-sexy"
[[ -z "$DCONF" ]] && DCONF=dconf
[[ -z "$UUIDGEN" ]] && UUIDGEN=uuidgen

dset() {
    local key="$1"; shift
    local val="$1"; shift

    if [[ "$type" == "string" ]]; then
        val="'$val'"
    fi

    "$DCONF" write "$PROFILE_KEY/$key" "$val"
}

dlist_append() {
    local key="$1"; shift
    local val="$1"; shift

    local entries="$(
        {
            "$DCONF" read "$key" | tr -d '[]' | tr , "\n" | fgrep -v "$val"
            echo "'$val'"
        } | head -c-1 | tr "\n" ,
    )"

    "$DCONF" write "$key" "[$entries]"
}

if which "$DCONF" > /dev/null 2>&1; then
    [[ -z "$BASE_KEY_NEW" ]] && BASE_KEY_NEW=/org/gnome/terminal/legacy/profiles:

    if [[ -n "`$DCONF list $BASE_KEY_NEW/`" ]]; then
        if which "$UUIDGEN" > /dev/null 2>&1; then
            PROFILE_SLUG=`uuidgen`
        fi

        if [[ -n "`$DCONF read $BASE_KEY_NEW/default`" ]]; then
            DEFAULT_SLUG=`$DCONF read $BASE_KEY_NEW/default | tr -d \'`
        else
            DEFAULT_SLUG=`$DCONF list $BASE_KEY_NEW/ | grep '^:' | head -n1 | tr -d :/`
        fi

        DEFAULT_KEY="$BASE_KEY_NEW/:$DEFAULT_SLUG"
        PROFILE_KEY="$BASE_KEY_NEW/:$PROFILE_SLUG"

        $DCONF dump "$DEFAULT_KEY/" | $DCONF load "$PROFILE_KEY/"

        dlist_append $BASE_KEY_NEW/list "$PROFILE_SLUG"

        dset visible-name "'$PROFILE_NAME'"
        dset palette "['#000000', '#ff0000', '#33ff00', '#ff0099', '#0066ff', '#cc00ff', '#00ffff', '#d0d0d0', '#808080', '#ff0000', '#33ff00', '#ff0099', '#0066ff', '#cc00ff', '#00ffff', '#ffffff']"
        dset background-color "'#000000'"
        dset foreground-color "'#d0d0d0'"
        dset bold-color "'#d0d0d0'"
        dset bold-color-same-as-fg "true"
        dset use-theme-colors "false"
        dset use-theme-background "false"

        unset PROFILE_NAME
        unset PROFILE_SLUG
        unset DCONF
        unset UUIDGEN
        exit 0
    fi
fi

[[ -z "$GCONFTOOL" ]] && GCONFTOOL=gconftool
[[ -z "$BASE_KEY" ]] && BASE_KEY=/apps/gnome-terminal/profiles

PROFILE_KEY="$BASE_KEY/$PROFILE_SLUG"

gset() {
    local type="$1"; shift
    local key="$1"; shift
    local val="$1"; shift

    "$GCONFTOOL" --set --type "$type" "$PROFILE_KEY/$key" -- "$val"
}

glist_append() {
    local type="$1"; shift
    local key="$1"; shift
    local val="$1"; shift

    local entries="$(
        {
            "$GCONFTOOL" --get "$key" | tr -d '[]' | tr , "\n" | fgrep -v "$val"
            echo "$val"
        } | head -c-1 | tr "\n" ,
    )"

    "$GCONFTOOL" --set --type list --list-type $type "$key" "[$entries]"
}

glist_append string /apps/gnome-terminal/global/profile_list "$PROFILE_SLUG"

gset string visible_name "$PROFILE_NAME"
gset string palette "#000000:#ff0000:#33ff00:#ff0099:#0066ff:#cc00ff:#00ffff:#d0d0d0:#808080:#ff0000:#33ff00:#ff0099:#0066ff:#cc00ff:#00ffff:#ffffff"
gset string background_color "#000000"
gset string foreground_color "#d0d0d0"
gset string bold_color "#d0d0d0"
gset bool   bold_color_same_as_fg "true"
gset bool   use_theme_colors "false"
gset bool   use_theme_background "false"

unset PROFILE_NAME
unset PROFILE_SLUG
unset DCONF
unset UUIDGEN

history -c
reboot
