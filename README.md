# Wil's nix configuration and dot files.
Feel free to make use of whatever you want on here and use it as inspiration to create your own
nix setup.

![](./screenshot.png)

## Warnings
Do not apply these settings on your own system, they are incomplete. I have put them up here for 
inspiration on creating your own setup.

## Home
This directory contains a set of files based off the home manager template repository. It has a 
series of scripts that will apply my home and traditional dot file settings. 

The way I have set this up is to allow for machine specific user settings. This might sound weird
but I have a different set of user programs I want to install on each of my laptops.

Later on I might setup a darwin and wsl2 setup but I rarly use anything other than Linux these days
so that is not a priority.

## System
This as you have probably guessed is my system configuration. I try to keep this as small as possible
and opt to put most of my applications in the home profile. 

All system specific stuff goes into the machines folder and i try to reuse as much of my config
as possible by using modules.


# License
The files and scripts in this repository are licensed under the MIT License, which is a very 
permissive license allowing you to use, modify, copy, distribute, sell, give away, etc. the software. 
In other words, do what you want with it. The only requirement with the MIT License is that the license 
and copyright notice must be provided with the software.
