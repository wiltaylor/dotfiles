# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/62b6381c-86d6-454f-b431-c9d1189bfb3f";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/59ed63ef-6bc3-4640-8020-94aa36b2a072";

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/62b6381c-86d6-454f-b431-c9d1189bfb3f";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

  fileSystems."/var" =
    { device = "/dev/disk/by-uuid/62b6381c-86d6-454f-b431-c9d1189bfb3f";
      fsType = "btrfs";
      options = [ "subvol=@var" ];
    };

  fileSystems."/.pagefile" =
    { device = "/dev/disk/by-uuid/62b6381c-86d6-454f-b431-c9d1189bfb3f";
      fsType = "btrfs";
      options = [ "subvol=@pagefile" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/8412-6A78";
      fsType = "vfat";
    };

  swapDevices = [ ];

  nix.maxJobs = lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  # High-DPI console
  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
}
