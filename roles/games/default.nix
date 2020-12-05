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

  services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  environment.systemPackages = with pkgs; [
    #(steam.override { 
    #  extraPkgs = pkgs: [mono gtk3 gtk3-x11 libgdiplus zlib ]; 
    #  nativeOnly = true; 
    #  withJava = true;
   # })
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
