{pkgs, lib, config, ...}:
{
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages32 = with pkgs.pkgsi686Linux; [
      libva
    ];
  };

  hardware.pulseaudio.support32Bit = true;
  hardware.steam-hardware.enable = true;

  environment.systemPackages = with pkgs; [
    steam
    steam-run
    glxinfo
    xonotic
    vkquake
    vulkan-tools
    vulkan-loader
    vulkan-headers
    #wine-staging
    #winePackages.staging
    #wineWowPackages.staging
    #winetricks
    minecraft
    quakespasm
  ];
}
