{ pkgs, ... }:
{
  services.xserver.videoDrivers = [ "amdgpu" ];
  services.xserver.deviceSection = ''
    Option "TearFree" "true"

  '';

  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  hardware.opengl.extraPackages = with pkgs; [
    amdvlk 
  ];

  hardware.opengl.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];
  
   environment.systemPackages = with pkgs; [
     vulkan-tools
     radeontop
   ];

  hardware.firmware = with pkgs;[ firmwareLinuxNonfree ];
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  nixpkgs.config.allowUnfree = true;
  hardware.opengl.enable = true;

}
