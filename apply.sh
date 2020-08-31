#!/bin/bash


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
chown -R $(whoami) ~/.gnupg/
chmod 700 ~/.gnupg -R
gpg --import gpg/.gnupg/public.key

