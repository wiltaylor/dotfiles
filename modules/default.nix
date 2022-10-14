{pkgs, ... }:
{
  imports = [
    ./core
    ./hotfix
    ./hardware
    ./desktop
    ./base
    ./user
  ];
}
