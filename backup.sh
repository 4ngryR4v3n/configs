#!/bin/bash

set -ex

repo=$(pwd)
home=$(cd ~/ && pwd)
commit=()
updated=False

cfg_git=$home/.gitconfig
if [ -f $cfg_git ]; then
    cp $cfg_git $repo/git
    commit+=("$cfg_git")
    updated=True
fi

cfg_terminator=$home/.config/terminator/config
if [ -f $cfg_terminator ]; then
    cp $cfg_terminator $repo/terminator
    commit+=("$cfg_terminator")
    updated=True
fi

cfg_vim=$home/.vimrc
if [ -f $cfg_vim ]; then
    cp $cfg_vim $repo/vim
    commit+=("$cfg_vim")
    updated=True
fi

cfg_xbindkeys=$home/.xbindkeysrc
if [ -f $cfg_xbindkeys ]; then
    cp $cfg_xbindkeys $repo/xbindkeys
    commit+=("$cfg_xbindkeys")
    updated=True
fi

cfg_zsh=$home/.zshrc
if [ -f $cfg_zsh ]; then
    cp $cfg_zsh $repo/zsh
    commit+=("$cfg_zsh")
    updated=True
fi

if [ "$updated" == True ]; then
    commit_str=$(printf "Update\n%s\n"  "${commit[@]}")

    cd $repo
    git add .
    git commit -m '`$commit_str`'
    git push
fi
