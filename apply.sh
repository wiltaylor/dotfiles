#!/bin/bash

#Git secret
git secret reveal -f

#Pulling in sub modules
git submodule update --init --recursive

#Deploying all config
stow alacritty
stow bspwm
stow doom-emacs
stow git
stow gpg
stow gtk
stow i3wm
stow polybar
stow kde
stow newsboat
stow nvim
stow ranger
stow rofi
stow tmux
stow zsh
stow maintanance
stow workprofile
stow wallpapers
stow vscode

#PGP Extra actions
chown -R $(whoami) ~/.gnupg/
chmod 700 ~/.gnupg -R
gpg --import gpg/.gnupg/public.key

#VSCode extra actions

cat ./vscode/.config/Code\ -\ OSS/extensions.txt | xargs -L 1 code --install-extension


# Apply ansilbe
compname=`cat /etc/hostname`
cd ansible

case $compname in 
    titan)
        ansible-playbook titan.yml -K
        ;;
    mini)
        ansible-playbook mini.yml -K
        ;;
esac

cd ..
