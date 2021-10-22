{pkgs, config, lib, ...}:
with lib;
with builtins;
let
  cfg = config.sys.graphics;
in {
  options.sys.graphics = {
    primaryGPU = mkOption {
      type = types.enum [ "amd" "intel" "nvidia" "none"];
      default = "none";
      description = "The primary gpu on your system that you want your desktop to display on";
    };

    extraGPU = mkOption {
      type = with types; listOf (enum ["amd" "intel" "nvidia"]);
      default = [];
      description = "Extra gpu your system has installed";
    };

    desktopProtocols = mkOption {
      type = with types; listOf (enum ["xorg" "wayland"]);
      default = [];
      description = "Desktop protocols you want to use for your desktop environment";
    };
  };

  config = let
    amd = (cfg.primaryGPU == "amd" || (elem "amd" cfg.extraGPU));
    amdPrimary = cfg.PrimaryGPU == "amd";

    intel = (cfg.primaryGPU == "intel" || (elem "intel" cfg.extraGPU));
    intelPrimary = cfg.PrimaryGPU == "intel";

    nvidia = (cfg.primaryGPU == "nvidia" || (elem "nvidia" cfg.extraGPU));
    nvidiaPrimary = cfg.PrimaryGPU == "nvidia";

    xorg = (elem "xorg" cfg.desktopProtocols);

    headless = cfg.primaryGPU == "none";
  in {

    boot.initrd.kernelModules = [
      (mkIf amd "amdgpu")
    ];

    services.xserver.videoDrivers = mkIf xorg [
      (mkIf amd "amdgpu") 
      (mkIf intel "intel")
      (mkIf nvidia "nvidia")
    ];

    services.xserver.deviceSection = mkIf xorg ''
      ${if (amd || intel) then ''
        Option "TearFree" "true"
      '' else ""}
    '';

    hardware.nvidia.modesetting.enable = nvidia;
    hardware.opengl.enable = !headless;
    hardware.opengl.driSupport = !headless;
    hardware.opengl.driSupport32Bit = !headless;
    hardware.steam-hardware.enable = !headless;

    hardware.opengl.extraPackages = mkIf (!headless) (with pkgs;[
      (mkIf amd amdvlk)
      (mkIf intel intel-media-driver)
      (mkIf intel vaapiIntel)
      (mkIf intel vaapiVdpau)
      (mkIf intel libvdpau-va-gl)

      libva
    ]);

    hardware.opengl.extraPackages32 = mkIf (!headless) (with pkgs.driversi686Linux;[
      (mkIf amd amdvlk)
      (mkIf intel vaapiIntel)
    ]);

    environment.systemPackages = with pkgs; [
      vulkan-tools
      glxinfo
      (mkIf amd radeontop)
      (mkIf intel libva-utils)
    ];
  };
}
