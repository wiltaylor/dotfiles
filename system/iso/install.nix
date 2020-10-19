{ config, pkgs, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
    ../modules
  ];

  wil.i3wm.enable = true;
  wil.sshd.enable = true;
  wil.yubikey.enable = true;
  wil.net.enable = true;
  wil.git.enable = true;
  wil.gpg.enable = true;

  networking.wireless.enable = true;
  networking.wireless.extraConfig = ''
    ctrl_interface=/run/wpa_supplicant
    ctrl_interface_group=wheel
  '';
  environment.systemPackages = with pkgs; [
    wpa_supplicant_gui
  ];
}

