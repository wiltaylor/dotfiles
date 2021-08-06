{ pkgs, ... }:
{
  services.xserver.videoDrivers = [ "amdgpu" ];
  services.xserver.deviceSection = ''
    Option "TearFree" "true"

  '';

  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.opengl.extraPackages = with pkgs; [
    amdvlk 
    rocm-opencl-icd
  ];

  hardware.opengl.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];
  
   environment.systemPackages = with pkgs; [
     vulkan-tools
     mesa mesa_drivers
     rocm-opencl-icd
     rocm-opencl-runtime
     opencl-icd
     opencl-info
     opencl-clang
     opencl-headers
     radeontop

   ];

  hardware.firmware = with pkgs;[ firmwareLinuxNonfree ];
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  nixpkgs.config.allowUnfree = true;
  hardware.opengl.enable = true;

}
