{pkgs, config, lib, ...}:
with lib;
with builtins;
let
  cfg = config.sys.graphics;
in {
  imports = [ ./vfio.nix ./scripts.nix ];

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

    displayManager = mkOption {
      type = types.enum ["none" "lightdm"];
      default = "none";
      description = "Select the display manager you want to boot the system with";
    };

    gpuSensorCommand = mkOption {
      type = types.str;
      description = "Command to get gpu temp";
    };

    v4l2loopback = mkEnableOption "Enable v4l2loop back on this system";
  };

  config = let
    amd = (cfg.primaryGPU == "amd" || (elem "amd" cfg.extraGPU));
    amdPrimary = cfg.PrimaryGPU == "amd";

    intel = (cfg.primaryGPU == "intel" || (elem "intel" cfg.extraGPU));
    intelPrimary = cfg.PrimaryGPU == "intel";

    nvidia = (cfg.primaryGPU == "nvidia" || (elem "nvidia" cfg.extraGPU));
    nvidiaPrimary = cfg.PrimaryGPU == "nvidia";

    xorg = (elem "xorg" cfg.desktopProtocols);
    desktopMode = xorg;

    headless = cfg.primaryGPU == "none";

    kernelPackage = config.sys.kernelPackage;
  in {

    boot.initrd.kernelModules = [
      (mkIf amd "amdgpu")
    ];

    boot.extraModprobeConfig = mkIf cfg.v4l2loopback ''
      options v4l2loopback exclusive_caps=1 video_nr=9 card_label="obs"
    '';

    boot.extraModulePackages = [
      (mkIf cfg.v4l2loopback kernelPackage.v4l2loopback)
    ];

    services.xserver = mkIf xorg {
      videoDrivers = [
        (mkIf amd "amdgpu") 
        (mkIf intel "intel")
        (mkIf nvidia "nvidia")
      ];

      deviceSection = mkIf (intel || amd) ''
        Option "TearFree" "true"
      '';

      enable = true;
      displayManager.lightdm.enable = cfg.displayManager == "lightdm";
      displayManager.job.logToJournal = true;
      libinput.enable = true;

    };

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
      (mkIf desktopMode vulkan-tools)
      (mkIf desktopMode vulkan-loader)
      (mkIf desktopMode vulkan-headers)
      (mkIf desktopMode glxinfo)
      (mkIf amd radeontop)
      (mkIf intel libva-utils)

      (mkIf cfg.v4l2loopback kernelPackage.v4l2loopback)
      (mkIf cfg.v4l2loopback libv4l)
      (mkIf cfg.v4l2loopback xawtv)
      (mkIf desktopMode ueberzug)
      (mkIf desktopMode dfeet)
    ];

    services.autorandr.enable = xorg;

  };
}
