{pkgs, config, lib, ...}:
with lib;
with builtins;
let
  xorg = (elem "xorg" config.sys.hardware.graphics.desktopProtocols);
  wayland = (elem "wayland" config.sys.hardware.graphics.desktopProtocols);
  desktopMode = xorg || wayland;
in {
  config = mkIf desktopMode {

  # Fix issue with java applications and tiling window managers.
  environment.sessionVariables = {
    "_JAVA_AWT_WM_NONREPARENTING" = "1";
  };

  environment.systemPackages = with pkgs; [
      xdg-desktop-portal-wlr
      pavucontrol
      pkgs.xorg.xmodmap
      maim
      xclip
      pkgs.xorg.xev
      feh
      foot
      libsixel
      mpv
      distrobox
      kdenlive
      gimp
      appimage-run

      dfeet
      pkgs.xorg.xhost
      virtmanager
      pandoc
      remmina
    ];
  };
}
