{pkgs, config, lib, ...}:
{

  imports = [
    ./spotify.nix
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
    vscodium-alias
    vscodium
    gitkraken
    #masterplan
  ];
}
