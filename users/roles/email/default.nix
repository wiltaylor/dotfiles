{pkgs, lib, config, ...}:
{
  home.packages = with pkgs; [
    neomutt
    protonmail-bridge
    offlineimap
  ];
}
