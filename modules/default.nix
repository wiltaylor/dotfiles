{pkgs, ... }:
{
  imports = [
    ./laptop
    ./core
    ./virtualisation
    ./graphics
    ./hotfix
    ./hardware
    ./shell
    ./development
    ./desktop
    ./base
    ./user
  ];
}
