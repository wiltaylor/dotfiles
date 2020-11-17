{pkgs, config, lib, ...}:
{
  home.file = {
    ".config/wallpapers".source = ../../../../wallpapers;
  };
}
