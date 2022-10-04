{pkgs, config, lib, ...}:
with pkgs;
with lib;
let
    cfg = config.sys;
in {
    options.sys.hardware.usb = {
        udisk2 = mkOption {
            description = "Enable udisk for easy mounting an unmounting of usb drives";
            type = types.bool;
            default = true;
        };
    };

    config = {
        services.udisk2.enable = cfg.hardware.usb.udisk2;
    };
}
