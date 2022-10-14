{ pkgs, config, lib, ...}:
with pkgs;
with builtins;
with lib;
let
  cfg = config.sys;
  cpuType = config.sys.cpu.type;
in {
  options.sys.hardware.vfio = {
    enable = mkEnableOption "Enable VFIO";
    gpuType = mkOption {
      type = types.enum ["nvidia"]; # Only tested with nvidia gpu.
      description = "Type of cpu being passed through";
      default = "nvidia";
    };

    gpuPciIds = mkOption {
      type = types.str;
      description = "This is the list of ids that needs to be passed to modprobe to set this up.";
      default = "";
    };

    devIds = mkOption {
      type = types.str;
      description = "This is the device ids that need to have driver override set on startup.";
      default = "";
    };

  };

  config = let
    nvidia = cfg.hardware.vfio.gpuType == "nvidia";
  in mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      looking-glass-client
      scream
    ];

    systemd.tmpfiles.rules = [
      "f /dev/shm/looking-glass 0660 wil qemu-libvirtd -"
    ];

    # Fixes issue where this link doesn't exist
    system.activationScripts.fixlibvirtsocket = {
      text = ''
        ln /run /var/lib/run -sf
      '';
    };

    # Force libvirtd on
    virtualisation.libvirtd = {
      enable = true;
      qemu.ovmf.enable = true;
    };

    # Currently this is only implimented for my amd cpu. Have not tried this on an intel cpu yet.
    boot.kernelParams = [ 
      (mkIf (cpuType == "amd") "amd_iommu=on")
      (mkIf (cpuType == "amd") "iommu=pt") 
    ];

    boot.kernelModules = [ "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];
    boot.extraModprobeConfig = "options vfio-pci ids=${cfg.hardware.vfio.gpuPciIds}";

    boot.blacklistedKernelModules = [ 
      (mkIf nvidia "nvidia")
      (mkIf nvidia "nouveau")
      (mkIf nvidia "nvidiafb")
    ];

    boot.postBootCommands = ''
      DEVS="${cfg.hardware.vfio.devIds}"

      for DEV in $DEVS; do
        echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
      done
      modprobe -i vfio-pci
    '';

  };
}
