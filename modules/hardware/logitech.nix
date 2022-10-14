{pkgs, lib, config, ...}:
with pkgs;
with lib;
with builtins;
let
    cfg = config.sys;
in {
    options.sys.hardware.g810led = mkEnableOption "Enable G810 Keyboard";

    config = {
        sys.software = [
            (mkIf (cfg.hardware.g810led) g810-led)
        ];

        services.udev.packages = [ 
            (mkIf (cfg.hardware.g810led) g810-led)
        ];
    };
}
