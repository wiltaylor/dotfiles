{pkgs, config, lib, ...}:
with lib;
with builtins;
let
  xorg = (elem "xorg" config.sys.graphics.desktopProtocols);
  wayland = (elem "wayland" config.sys.graphics.desktopProtocols);
  desktopMode = xorg || wayland;

  emacs-custom = pkgs.writeScriptBin "emacs" ''
    ${pkgs.emacs}/bin/emacs -q -l ~/.config/emacs/init.el $@
  '';
in {

  config = mkIf desktopMode {
  environment.systemPackages = with pkgs; [
     firefox
      pavucontrol
      pkgs.xorg.xmodmap
      maim
      xclip
      pkgs.xorg.xev
      feh
      mpv
      gimp
      virt-manager
      youtube-dl

      # This stuff should be moved to work shell eventually
      google-chrome
      my.vscodium-alias
      vscodium
      gitkraken
      dfeet
      jetbrains.rider
      jetbrains.pycharm-professional
      pcmanfm
      openspades
      neovimWT
      ytfzf
      obs-studio
      nyxt
      emacs-custom
    ];
  };
}
