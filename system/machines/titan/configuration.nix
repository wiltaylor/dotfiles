
# __          ___ _   _______          _
# \ \        / (_) | |__   __|        | |
#  \ \  /\  / / _| |    | | __ _ _   _| | ___  _ __
#   \ \/  \/ / | | |    | |/ _` | | | | |/ _ \| '__|
#    \  /\  /  | | |    | | (_| | |_| | | (_) | |
#     \/  \/   |_|_|    |_|\__,_|\__, |_|\___/|_|
#                                 __/ |
#                                |___/
# Web: https://wil.dev
# Github: https://github.com/wiltaylor
# Contact: web@wiltaylor.dev
# Feel free to use this configuration as you wish.
{ config, pkgs, lib, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelModules = [ "kvm-intel" ];
  virtualisation.libvirtd.enable = true;

  # Host specific network settings
  networking.hostName = "titan"; 
  networking.interfaces.enp62s0.useDHCP = true;
  networking.interfaces.wlp63s0.useDHCP = true;
  networking.firewall.allowedTCPPorts = [ ];

  wil.desktop.x11 = {
    enable = true;
    drivers = [ "nvidia" ];
  };
  
  wil.hardware.g810led.enable = true;
  wil.sshd.enable = true;
  wil.yubikey.enable = true;
  wil.net.enable = true;
}

