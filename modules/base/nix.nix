{pkgs, config, lib, ...}:
with pkgs;
with lib;
let
    cfg = config.sys;
in {
    nixpkgs.config.allowUnfree = true;
    
    nix = {
        settings = {
            max-jobs = cfg.cpu.cores * cfg.cpu.threadsPerCore * cfg.cpu.sockets;
        };

        extraOptions = "experimental-features = nix-command flakes";
        gc = {
            automatic = true;
            options = "--delete-older-than 5d";
        };
    };
}
