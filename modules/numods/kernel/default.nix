{ config, lib, pkgs, ...}:
with lib;
{

  options.kernel = {
    enable = mkEnableOption "Enable Kernel";
  };
}
