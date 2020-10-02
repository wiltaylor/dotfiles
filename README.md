# Wil's dot files
Here are my personal dotfiles which i deploy whenever I setup a new machine. 
Feel free to copy and use anything you want from it.

This is a constant work in progress so if you deploy it to your own machine don't 
be suprised if it just randomy breaks. The idea is you should get inspiration to 
create your own configuration not just blindly apply mine.

# Nix
I have recently moved my dotfiles over from a stow based workflow to a nix based one.

This was mainly done due to the fact I moved over to NixOS from Arch. This was done
due to the pure nature of how nix works. It means I can have a heap of different
tool chains on my system without them messing with each other.

# System config
To setup a nixos system from scratch see the machines folder.

# Applying home-manager config from this repo.
1. Clone the repo to ~/.dotfiles 
2. Run update.sh

# License
The files and scripts in this repository are licensed under the MIT License, which is a very 
permissive license allowing you to use, modify, copy, distribute, sell, give away, etc. the software. 
In other words, do what you want with it. The only requirement with the MIT License is that the license 
and copyright notice must be provided with the software.
