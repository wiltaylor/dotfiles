{ config, pkgs, lib, ... }:
with lib;

let 
  cfg = config.sys.hardware;
in {
    options.sys.hardware = {
      g810led = mkEnableOption "Enable G810 Keyboard led control";
      kindle = mkEnableOption "Enable Amazon Kindle";
    };

    config = let
      g810pkg = pkgs.g810-led;
    in {
      environment.systemPackages = [
        (mkIf (cfg.g810led) pkgs.g810-led)
        (mkIf (cfg.kindle) pkgs.libmtp)
        (mkIf (cfg.kindle) pkgs.gvfs)
      ];

      boot.kernelModules = [
        (mkIf cfg.kindle "msdos")
      ];

      services.udev.packages = with pkgs; [ g810-led];
    };
}
