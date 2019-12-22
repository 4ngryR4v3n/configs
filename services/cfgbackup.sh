#!/usr/bin/env bash

set -euxo pipefail
cd

home=$(cd && pwd)
cfgdir="$home/.cfg/configs"
int=60

[ -d "$cfgdir" ] || git clone https://github.com/Perdyx/configs.git $home/.cfg

function check() {
    cfg=$1
    s1=$(sha1sum $cfg)
}

function compare() {
    if [ -f "$cfg" ]; then
        s2=$(sha1sum $cfg)

        if [ "$s1" != "$s2" ]; then
            cp $cfg $1
        fi
    fi
}

while true; do
    dconf dump / > $cfgdir/dconf/$(cat /etc/*-release | grep "DISTRIB_ID" | sed 's/DISTRIB_ID=//')

    check "$home/.gitconfig"
    check "$home/.config/terminator/config"
    check "$home/.vimrc"
    check "$home/.xbindkeysrc"
    check "$home/.zshrc"

    sleep $int

    compare "$cfgdir/git/.gitconfig"
    compare "$cfgdir/terminator/config"
    compare "$cfgdir/vim/.vimrc"
    compare "$cfgdir/xbindkeys/.xbindkeysrc"
    compare "$cfgdir/zsh/.zshrc"
done
