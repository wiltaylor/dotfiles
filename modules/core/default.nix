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

    cpuType = mkOption {
      type = types.enum ["intel" "amd"];
      description = "Type of cpu the system has in it";
    };
  };

  config = {
    # Enable all unfree hardware support.
    hardware.firmware = with pkgs; [ firmwareLinuxNonfree ];
    hardware.enableAllFirmware = true;
    hardware.enableRedistributableFirmware = true;
    nixpkgs.config.allowUnfree = true;

    boot.kernelPackages = cfg.kernelPackage;

    environment.systemPackages = with pkgs; [
      (mkIf (cfg.cpuType == "amd") microcodeAmd)
      (mkIf (cfg.cpuType == "intel") microcodeIntel)
    ];
  };
}
