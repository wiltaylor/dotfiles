{pkgs, config, lib, ...}:
{
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
    google-chrome # TODO: Move to work shell so i can get this off my main profile
  ];
}
