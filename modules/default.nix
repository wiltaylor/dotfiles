{pkgs, ... }:
{
  imports = [
    ./core
    ./virtualisation
    ./hotfix
    ./hardware
    ./shell
    ./development
    ./desktop
    ./base
    ./user
  ];
}
