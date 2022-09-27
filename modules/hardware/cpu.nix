{pkgs, config, lib, ...}:
with pkgs;
with lib;
let
    cfg = config.sys;
in {
    options.sys = {
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

      sensorCommand = mkOption {
        type = types.str;
        description = "Command to get cpu temp";
      };
    };
   };

   config = {
        boot.kernelParams = [
            (mkIf (cfg.cpu.type == "intel") "intel_pstate=active")
        ];

        sys.software = [
            (mkIf (cfg.cpu.type == "amd") microcodeAmd)
            (mkIf (cfg.cpu.type == "intel") microcodeIntel)
        ];
   };
}
