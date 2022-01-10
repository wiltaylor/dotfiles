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

# License
The files and scripts in this repository are licensed under the MIT License, which is a very 
permissive license allowing you to use, modify, copy, distribute, sell, give away, etc. the software. 
In other words, do what you want with it. The only requirement with the MIT License is that the license 
and copyright notice must be provided with the software.
