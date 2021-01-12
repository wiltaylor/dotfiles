{ pkgs, ... }:
{
  services.xserver.videoDrivers = [ "amdgpu" ];
#  services.xserver.deviceSection = ''
#    BusID "PCI:B:0:0" 
#  '';

#boot.initrd.kernelModules = [ "amdgpu" ];

#  hardware.opengl.extraPackages = with pkgs; [
#    rocm-opencl-icd
#    rocm-opencl-runtime
#  ];

   boot.kernelPatches = [{
     name = "AMD 6800XT fix";
     patch = null;
     extraConfig = ''
       DRM_AMD_DC y
       DRM_AMD_DC_DCN y
       DRM_AMD_DC_DCN3_0 y
     '';
   }];

  environment.systemPackages = with pkgs; [ vulkan-tools mesa mesa_drivers  ];

  hardware.firmware = with pkgs.unstable; [ firmwareLinuxNonfree ];
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  nixpkgs.config.allowUnfree = true;
  hardware.opengl.enable = true;

}
