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
    #(steam.override { 
    #  extraPkgs = pkgs: [mono gtk3 gtk3-x11 libgdiplus zlib ]; 
    #  nativeOnly = true; 
    #  withJava = true;
   # })
    (steam.override { extraPkgs = pkgs: [ mono gtk3 gtk3-x11 libgdiplus zlib ]; withJava = true; })
    steam-run
    glxinfo
    xonotic
    vkquake
    lutris
    vulkan-tools
    vulkan-loader
    vulkan-headers

  ];
}
