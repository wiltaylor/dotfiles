{pkgs, lib, config, ...}:
with pkgs;
with lib;
with builtins;
let
    cfg = config.sys;
in {
    options.sys.virtualisation = {
        docker = {
            enable = mkOption {
                type = types.bool;
                default = true;
                description = "Enables docker";
            };
        };
    };

    config = {
        virtualisation.docker.enable = cfg.virtualisation.docker.enable;
        virtualisation.docker.storageDriver = "overlay2";
    };
}
