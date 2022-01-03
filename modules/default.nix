{pkgs, ... }:
{
  imports = [
    ./laptop
    ./core
    ./virtualisation
    ./graphics
    ./audio
    ./hotfix
    ./hardware
    ./shell
    ./development
    ./desktop
  ];
}
