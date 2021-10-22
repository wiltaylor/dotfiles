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

    cpu = {
      type = mkOption {
        type = types.enum ["intel" "amd"];
        description = "Type of cpu the system has in it";
      };

      cores = mkOption {
        type = types.int;
        default = 1;
        description = "Number of physical cores on cpu per socket";
      };

      sockets = mkOption {
        type = types.int;
        default = 1;
        description = "Number of CPU sockets installed in system";
      };

      threadsPerCore = mkOption {
        type = types.int;
        default = 1;
        description = "Number of threads per core.";
      };
    };
  };

  config = let
    cpu = cfg.cpu;
  in {
    # Enable all unfree hardware support.
    hardware.firmware = with pkgs; [ firmwareLinuxNonfree ];
    hardware.enableAllFirmware = true;
    hardware.enableRedistributableFirmware = true;
    nixpkgs.config.allowUnfree = true;

    boot.kernelPackages = cfg.kernelPackage;

    environment.systemPackages = with pkgs; [
      (mkIf (cpu.type == "amd") microcodeAmd)
      (mkIf (cpu.type == "intel") microcodeIntel)
    ];

    nix.maxJobs = cpu.cores * cpu.threadsPerCore * cpu.sockets;
  };
}
