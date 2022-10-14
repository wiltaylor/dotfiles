{pkgs, lib, config, ...}:
with pkgs;
with lib;
with builtins;
let
    cfg = config.sys;
in {
    options.sys.hardware = {
      bluetooth = mkEnableOption "System has a bluetooth adapter";
    };

    config = {
      hardware.bluetooth.enable = cfg.hardware.bluetooth;
      services.blueman.enable = cfg.hardware.bluetooth;

    };
}
