{config, lib, pkgs, ...}:
with lib;
{
    options.laptop = mkOption {
      type = types.package;
      default = false;
      description = "Tags machine as a laptop or not";
    };
}
