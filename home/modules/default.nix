{pkgs, ... }:
{
  config = {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = import ./pkgs;
  };

  imports = [
    ./gpg
    ./keyboard.nix
    ./dunst.nix
    ./nvim.nix
    ./spotify
    ./alacritty
  ];
}
