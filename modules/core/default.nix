{config, pkgs, lib, ...}:
with lib;
with builtins;
let
  cfg =  config.sys;
in {

  imports = [ ./scripts.nix ];
  options.sys = {
    kernelPackage = mkOption {
      default = pkgs.linuxPackages_latest;
      description = "Kernel package used to build this system";
    };
  };

  config = {
    boot.kernelPackages = cfg.kernelPackage;
  };
}
