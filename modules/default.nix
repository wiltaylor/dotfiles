{pkgs, ... }:
{
  #nixpkgs.overlays = overlay;

  imports = [
    ./laptop
    ./core
    ./virtualisation
    ./graphics
    ./audio
    ./hotfix
    ./hardware
    ./games
  ];
}
