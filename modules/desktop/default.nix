{lib, config, pkgs, ...}:
{
  imports = [
    ./fonts.nix
    ./gtk.nix
    ./qt.nix
    ./wallpapers.nix
    ./launchers.nix
    ./picom.nix
  ];


}
