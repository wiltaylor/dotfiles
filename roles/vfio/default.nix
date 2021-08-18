{pkgs, ...}:
let
  winvmscript = pkgs.writeScriptBin "windows10-vm" ''
    sudo virsh start Windows10
    scream -o pulse &
    #scream-ivshmem-pulse /dev/shm/scream &
    looking-glass-client -f /dev/shm/looking-glass input:hideCursor=yes
    killall scream
  '';

  macosscript = pkgs.writeScriptBin "macos-vm" ''
    cd /vmstore/macos/macOS-Big-Sur
    ./OpenCore-Boot.sh
  '';
in {
  boot.kernelParams = [ "amd_iommu=on" "iommu=pt" ];
  boot.blacklistedKernelModules = [ "nvidia" "nouveau" "nvidiafb" ];

  boot.kernelModules = [ "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];
  boot.extraModprobeConfig = "options vfio-pci ids=10de:1e87,10de:10f8,10de:1ad8,10de:1ad9";

  boot.postBootCommands = ''
    DEVS="0000:0c:00.0 0000:0c:00.1 0000:0c:00.2 0000:0c:00.3"

    for DEV in $DEVS; do
      echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
    done
    modprobe -i vfio-pci
  '';

  virtualisation.libvirtd = {
    enable = true;
    qemuOvmf = true;
  };

  boot.initrd.luks.devices."vmcrypt".device = "/dev/disk/by-label/VMCRYPT";

  fileSystems."/vmstore" = 
  {
    device = "/dev/disk/by-label/VMSTORE";
    fsType = "btrfs";
    options = [ "subvol=@" ];
  };

  nixpkgs.config.pulseaudio = true;

  environment.systemPackages = with pkgs; [
    looking-glass-client
    ( scream.override { pulseSupport = true; })
    winvmscript
    macosscript
  ];

  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 wil qemu-libvirtd -"
    "f /dev/shm/scream 0660 wil quem-libvirtd -"
  ];

  # Fixes issue where this link doesn't exist
  system.activationScripts.fixlibvirtsocket = {
    text = ''
      ln /run /var/lib/run -sf
    '';
  };
}
