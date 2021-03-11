{pkgs, config, lib, ...}:
{

  imports = [
    ./spotify.nix
    ./steam.nix
  ];

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

    # This stuff should be moved to work shell eventually
    google-chrome
    my.vscodium-alias
    vscodium
    gitkraken
    dfeet
    blender
    jetbrains.pycharm-professional
    element-desktop
    xournalpp
    obsidian
#    cinelerra
    pcmanfm
  ];
}
