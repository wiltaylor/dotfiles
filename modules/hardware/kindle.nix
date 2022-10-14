{pkgs, lib, config, ...}:
with pkgs;
with lib;
with builtins;
let
    cfg = config.sys;
in {
    options.sys.hardware.kindle = mkEnableOption "Enable Amazon Kindke";

    config = mkIf cfg.hardware.kindle {
       sys.software = [
            libmtp
            gvfs
       ];

       boot.kernelModules = [
            "msdos"
       ];
    };
}
