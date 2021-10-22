{config, lib, pkgs, ...}:
with lib;
{
  imports = [ ./alienware.nix ];

    options.laptop = mkOption {
      type = types.package;
      default = false;
      description = "Tags machine as a laptop or not";
    };
}
