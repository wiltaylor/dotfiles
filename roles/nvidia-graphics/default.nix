{ pkgs, ... }: 
{
  services.xserver.videoDrivers = [ "nvidia" "modesetting" ];

  hardware.nvidia.modesetting.enable = true;
  environment.systemPackages = with pkgs; [ vulkan-tools ];

}
