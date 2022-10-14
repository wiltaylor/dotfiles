{config, pkgs, lib, ...}:
with lib;
with builtins;
let
  cfg =  config.sys;
in {

  imports = [ 
    ./scripts.nix 
    ./user.nix
  ];

  options.sys = {
      software = mkOption {
        type = with types; listOf package;
        description = "List of software to install";
        default = [];
      };
    
    security.secrets = mkOption {
      type = types.attrs;
      description = "Secrets are loaded into this set if git crypt is unlocked. Otherwise it is empty.";
      default = {};
    };
  };

  config = {
    environment.systemPackages = cfg.software;
  };
}
