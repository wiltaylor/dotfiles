{pkgs, config, lib, ...}:
with lib;
let
  emacs-custom = pkgs.writeScriptBin "emacs" ''
    ${pkgs.emacs}/bin/emacs -q -l ~/.config/emacs/init.el $@
  '';
in {

  home.sessionVariables = {
    ZKDIR = "$HOME/.zk";
    EDITOR = "vim";
  };

  home.packages = with pkgs;[
    firefox
    pavucontrol
    xorg.xmodmap
    maim
    xclip
    xorg.xev
    feh
    mpv
    gimp
    virt-manager
    youtube-dl
    wpsoffice

    # This stuff should be moved to work shell eventually
    google-chrome
    my.vscodium-alias
    vscodium
    gitkraken
    dfeet
    #blender
    jetbrains.rider
    jetbrains.pycharm-professional
    element-desktop
    #xournalpp
    mupdf
    foxitreader
    obsidian
#    cinelerra
    kn
    xmind
    pcmanfm
    openspades
    neovimWT
    ytfzf
    obs-studio
    lutris
    zotero
    superTuxKart
    nyxt
    emacs-custom
  ];
}
