{pkgs, lib, config, ...}:
{

  environment.systemPackages = with pkgs; [
    steam
    steam-run
    xonotic
    vkquake
    vulkan-tools
    vulkan-loader
    vulkan-headers
    wine-staging
    winePackages.staging
    wineWowPackages.staging
    winetricks
    minecraft
    quakespasm
  ];
}
