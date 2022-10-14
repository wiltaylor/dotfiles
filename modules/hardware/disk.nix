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
        services.udisks2.enable = cfg.hardware.usb.udisk2;

        # Pretty much all of my systems have ssd these days.
        # So we should always enable trim.
        services.fstrim.enable = true;
    };
}
