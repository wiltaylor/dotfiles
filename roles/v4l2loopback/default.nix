{pkgs, config, lib, ...}:
with lib;
with builtins;
let
  kernelPackage = config.wt.machine.kernelPackage;
in {
  boot.extraModprobeConfig = ''
    options v4l2loopback exclusive_caps=1 video_nr=9 card_label="obs"
  '';

  boot.extraModulePackages = [
    pkgs.linuxPackages_latest.v4l2loopback
  ];

  environment.systemPackages = with pkgs; [

    kernelPackage.v4l2loopback
    #l4vl-utils
    libv4l
    xawtv
  ];

}
