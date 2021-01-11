{pkgs, ...}:
{
  boot.blacklistedKernelModules = [ "nvidia" "nouveau" ];
  boot.kernelParams = [ "amd_iommu=on" "pcie_aspm=off" ];

  boot.kernelModules = [ "kvm-amd" "vfio_virqfd" "vfio-pci" "vfio_iommu_type1" "vfio" ];
  boot.extraModprobeConfig = "options vfio-pci ids=10de:1e87,10de:1ef8,10de:1ad8,10de:1ad9";

  boot.postBootCommands = ''
    DEVS="0000:0c:00.0 0000:0c:00.1 0000:0c:00.2 0000:0c:00.3"

    for DEV in $DEVS; do
      echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
    done

    modprobe -i vfio-pci
  '';
}
