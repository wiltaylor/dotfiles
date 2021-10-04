{config, pkgs, lib, ...}:
with lib;
with builtins;
let
  cfg =  config.wt.machine;
in {
  options.wt.machine = {
    kernelPackage = mkOption {
      default = pkgs.linuxPackages_latest;
      description = "Kernel package used to build this system";
    };
  };

  config = {
    boot.kernelPackages = cfg.kernelPackage;
  };
}
