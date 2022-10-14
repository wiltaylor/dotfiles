{pkgs, ... }:
{
  imports = [
    ./core
    ./hotfix
    ./hardware
    ./development
    ./desktop
    ./base
    ./user
  ];
}
