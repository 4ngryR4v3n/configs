#!/usr/bin/env bash

set -euxo pipefail
cd

home=$(cd && pwd)
cfgdir="$home/.cfg/configs"
int=300

[ -d "$cfgdir" ] || git clone https://github.com/Perdyx/configs.git $home/.cfg

while true; do
    dconf dump / > $cfgdir/dconf/$(cat /etc/*-release | grep "DISTRIB_ID" | sed 's/DISTRIB_ID=//')

    cp $home/.gitconfig $cfgdir/git/.gitconfig
    cp $home/.config/terminator/config $cfgdir/terminator/config
    cp $home/.vimrc $cfgdir/vim/.vimrc
    cp $home/.xbindkeysrc $cfgdir/xbindkeys/.xbindkeysrc
    cp $home/.zshrc $cfgdir/zsh/.zshrc

    sleep $int
done
