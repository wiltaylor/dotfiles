{pkgs, config, lib, ...}:
with lib;
with builtins;
let
  xorg = (elem "xorg" config.sys.graphics.desktopProtocols);
  wayland = (elem "wayland" config.sys.graphics.desktopProtocols);
  desktopMode = xorg || wayland;

  emacs-custom = pkgs.writeScriptBin "emacs-run" ''
    ${pkgs.emacs-sqlite}/bin/emacs -q -l ~/.config/emacs/init.el $@
  '';
in {



  config = mkIf desktopMode {

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

      dfeet
      pkgs.xorg.xhost

      firefox
      (distrobox.overrideAttrs (old: { 
	version = "1.4.1";
	
      	src = fetchFromGitHub {
    		owner = "89luca89";
    		repo = "distrobox";
    		rev = "1.4.1";
    		sha256 = "sha256-WIpl3eSdResAmWFc8OG8Jm0uLTGaovkItGAZTOEzhuE=";
        };
      }))
    ];
  };
}
