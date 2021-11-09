{pkgs, lib, config, ...}:
with lib;
with builtins;
let
  xorg = (elem "xorg" config.sys.graphics.desktopProtocols);
  desktopMode = xorg;
in {
  config = mkIf desktopMode {
    environment.systemPackages = with pkgs; [
      picom
    ];

    services.picom = {
      enable = true;
      fade = true;
      fadeDelta = 5;
      shadow = false;
      backend = "glx";
    };
  };
}
