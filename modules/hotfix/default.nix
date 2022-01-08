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
  };

  config = {
    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';

    environment.pathsToLink = ["/libexec" ];

    boot.kernelPatches = [ (mkIf cfg.kernelVectorWarning {
      name = "kernelVectorWarning";
      patch = ./no-irq-handler-for-vector.patch;
    })]; 
  };
}
