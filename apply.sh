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
stow kde
stow newsboat
stow nvim
stow ranger
stow rofi
stow tmux
stow zsh


gpg --import gpg/.gnupg/public.key

