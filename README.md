# What is this?
This is my collection of dot files which I use to build my Linux systems and 
control how they are configured.

For more information on NixOS the Linux distribution I use and also nix
the packaging tool and language that most of this repository is writen in
go to [NixOS Web site](https://nixos.org/).

![screenshot](./screenshot.png)

# Warnings
Do not apply these settings on your own system, they are incomplete. I have put them up here for 
inspiration on creating your own setup.

# Folder structure

```
|-[modules] -- Contains all the modules that make up this configuraiton
|-[lib] -- Contains my utility functions
|-[roles] -- Contains roles which can be applied to machines.
|-[wallpapers] -- drop images into this folder to add to wallpaper cycle.
|-LICENSE - MIT License file.
|-flake.nix - Cotains the main nix flake.
|-shell.nix - Creates a nix shell with required tools to install.
```

# HowTo
These dot files can be installed onto a system by 1 of two ways:

## Already running nixos system
If you have setup a nixos system with a configuration.nix file its possible to switch over to this nix config with
the following commands:

```shell
nix-shell
nixos-rebuild switch --flake .#
```

The above assuse your computer name matches one of the configurations in the flake.


## Via install media
You can also install this via the install media in the nix-install repo by doing the following:

- Boot off the install media.
- Create the partition schedume and mount it to /mnt
- Run `nixos-install --flake github:wiltaylor/dotfiles`

## sys tool
I created a helper script that is located in modules/core/scripts.nix file in this repo. It handles a number of different
maintanance functions for me (saves me having to remember a heap of commands):

```
Usage:
sys command

Commands:
clean - GC and hard link nix store
update - Updates dotfiles flake.
update-index - Updates the index of commands in nixpkgs. Used for exec
find - Find a nix package (searches all overlays)
find-doc - Finds documentation on a config item
find-cmd - Finds the package a command is in
apply - Applies current system configuration in dotfiles.
exec - executes a command from any nix pkg without permanantly installing it.
```
# License
The files and scripts in this repository are licensed under the MIT License, which is a very 
permissive license allowing you to use, modify, copy, distribute, sell, give away, etc. the software. 
In other words, do what you want with it. The only requirement with the MIT License is that the license 
and copyright notice m:w
ust be provided with the software.
