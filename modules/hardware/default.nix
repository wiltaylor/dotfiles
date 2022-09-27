{ config, pkgs, lib, ... }:
with lib;

let 
  cfg = config.sys.hardware;
in {

    imports = [ 
        ./software.nix
        ./cpu.nix
        ./firmware.nix
    ];

    options.sys.hardware = {
      g810led = mkEnableOption "Enable G810 Keyboard led control";
      kindle = mkEnableOption "Enable Amazon Kindle";
      bluetooth = mkEnableOption "System has a bluetooth adapter";
    };

    config = let
      g810pkg = pkgs.g810-led;
    in {

      environment.systemPackages = [
        (mkIf (cfg.g810led) pkgs.g810-led)
        (mkIf (cfg.kindle) pkgs.libmtp)
        (mkIf (cfg.kindle) pkgs.gvfs)
        pkgs.piper
        pkgs.libratbag
      ];

      boot.kernelModules = [
        (mkIf cfg.kindle "msdos")
      ];

      services.udev.packages = with pkgs; [ g810-led];

      services.fwupd.enable = true;
      services.fstrim.enable = true;

      hardware.bluetooth.enable = cfg.bluetooth;
      services.blueman.enable = cfg.bluetooth;

    };
}
