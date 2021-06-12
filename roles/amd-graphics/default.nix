{ pkgs, ... }:
{
  services.xserver.videoDrivers = [ "amdgpu" ];
  services.xserver.deviceSection = ''
    Option "TearFree" "true"

  '';

#boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.opengl.extraPackages = with pkgs; [
    amdvlk 
    rocm-opencl-icd
  ];

  hardware.opengl.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];


  
#   boot.kernelPatches = [{
#     name = "AMD 6800XT fix";
#     patch = null; # ./amd.patch;
#     extraConfig = ''
#       DRM_AMD_DC y
#       DRM_AMD_DC_DCN y
#       DRM_AMD_DC_DCN3_0 y
#     '';
#   }];

   environment.systemPackages = with pkgs; [
     vulkan-tools
     mesa mesa_drivers
     rocm-opencl-icd
     rocm-opencl-runtime
     rocm-runtime
     rocm-smi
     rocm-thunk
     rocm-comgr
     rocm-device-libs
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

  environment.variables.VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";

}
