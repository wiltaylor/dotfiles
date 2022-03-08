{pkgs, config, lib, ...}:
with pkgs;
with builtins;
with lib;
let
  cfg = config.sys.hotfix;
in {
  ## This module is a place to put hacks that need to be applied to work around current issues.
  ## You should check back here periodically to see if they can be removed.

  options.sys.hotfix = {
    kernelVectorWarning = mkOption {
      type = types.bool;
      default = false;
      description = "Patch kernel to lower priority of No irc handler for vector";
    };

    CVE-2022-0847 = mkOption {
      type = types.bool;
      default = false;
      description = "CVE-2022-0847 vuln. This is patched in 5.16.11, 5.15.25 and 5.10.102";
    };
  };

  config = {
    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';

    environment.pathsToLink = ["/libexec" ];

    boot.kernelPatches = [ 
    (mkIf cfg.kernelVectorWarning {
      name = "kernelVectorWarning";
      patch = ./no-irq-handler-for-vector.patch;
    })

    (mkIf cfg.CVE-2022-0847 {
      name = "CVE-2022-0847";
      patch = ./CVE-2022-0847.patch;
    })

    ]; 
  };
}
