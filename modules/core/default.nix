{config, pkgs, lib, ...}:
with lib;
with builtins;
let
  cfg =  config.sys;
in {

  imports = [ 
    ./scripts.nix 
    ./nixos.nix
    ./security.nix
    ./regional.nix
    ./network.nix
    ./user.nix
  ];

  options.sys = {
      software = mkOption {
        type = with types; listOf package;
        description = "List of software to install";
        default = [];
      };
  };

  config = {
    environment.systemPackages = cfg.software;
  };
}
