{pkgs, lib, config, ...}:
with pkgs;
with lib;
with builtins;
let
  cfg = config.sys.desktop.usb;
in {
  options.sys.desktop.usb = {
    udisk2 = mkOption {
      description = "Enable udisk for desktop environment";
      type = types.bool;
      default = false;
    };


  };

  config = mkIf cfg.udisk2 {
    services.udisks2.enable = true;

    #TODO: More options like mounting to media

  };
}
