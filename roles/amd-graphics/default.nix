{ pkgs, ... }:
{
  services.xserver.videoDrivers = [ "amdgpu" ];
  services.xserver.deviceSection = ''
    BusID "PCI:B:0:0" 
  '';

#boot.initrd.kernelModules = [ "amdgpu" ];

#  hardware.opengl.extraPackages = with pkgs; [
#    rocm-opencl-icd
#    rocm-opencl-runtime
#  ];

  environment.systemPackages = with pkgs; [ vulkan-tools firmwareLinuxNonfree mesa mesa_drivers xorg.xf86videoamdgpu ];

}
