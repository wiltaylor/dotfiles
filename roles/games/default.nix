{pkgs, lib, config, ...}:
{
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    extraPackages32 = with pkgs.pkgsi686Linux; [
      libva
    ];
  };

  hardware.pulseaudio.support32Bit = true;
  hardware.steam-hardware.enable = true;

  environment.systemPackages = with pkgs; [
    master.steam
    master.steam-run
    glxinfo
    xonotic
    vkquake
    lutris
    vulkan-tools
    vulkan-loader
    vulkan-headers
    wine-staging
    winePackages.staging
    wineWowPackages.staging
    winetricks
  ];
}
