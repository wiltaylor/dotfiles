{config, pkgs, lib, ...}:
with lib;
let
  cfg = config.wil.nixos;
in {
    
  options.wil.nixos = {
    disableGC = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Disable to turn off gc options. You should leave by default.
      '';
    };
  };

  config = {
    system.stateVersion = "20.09";

    nix.gc = mkIf (cfg.disableGC == false)  {
      automatic = true;
      options = "--delete-older-than 5d";
    };
  };
}
