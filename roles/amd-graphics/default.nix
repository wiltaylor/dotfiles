{ pkgs, ... }:
{
  services.xserver.videoDrivers = [ "amdgpu" ];
  services.xserver.deviceSection = ''
    Option "TearFree" "true"

  '';

#boot.initrd.kernelModules = [ "amdgpu" ];

#  hardware.opengl.extraPackages = with pkgs; [
#    rocm-opencl-icd
#    rocm-opencl-runtime
#  ];

   boot.kernelPatches = [{
     name = "AMD 6800XT fix";
     patch = null; # ./amd.patch;
     extraConfig = ''
       DRM_AMD_DC y
       DRM_AMD_DC_DCN y
     '';
   }];

  environment.systemPackages = with pkgs; [ vulkan-tools mesa mesa_drivers  ];

  hardware.firmware = with pkgs.unstable; [ firmwareLinuxNonfree ];
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  nixpkgs.config.allowUnfree = true;
  hardware.opengl.enable = true;

  environment.variables.VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";

}
