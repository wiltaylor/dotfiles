{lib, config, pkgs, ...}:
{
  imports = [
    ./fonts.nix
    ./gtk.nix
    ./qt.nix
    ./wallpapers.nix
    ./launchers.nix
    ./picom.nix
    ./dunst.nix
    ./terminal.nix
    ./applications.nix
    ./i3.nix
    ./plymouth.nix
    ./sway.nix
    ./kanshi.nix
  ];


}
