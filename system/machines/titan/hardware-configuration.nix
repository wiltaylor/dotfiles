# __          ___ _   _______          _
# \ \        / (_) | |__   __|        | |
#  \ \  /\  / / _| |    | | __ _ _   _| | ___  _ __
#   \ \/  \/ / | | |    | |/ _` | | | | |/ _ \| '__|
#    \  /\  /  | | |    | | (_| | |_| | | (_) | |
#     \/  \/   |_|_|    |_|\__,_|\__, |_|\___/|_|
#                                 __/ |
#                                |___/
# Web: https://wil.dev
# Github: https://github.com/wiltaylor
# Contact: web@wiltaylor.dev
# Feel free to use this configuration as you wish.

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

    swapDevices = [ 
      {
        device = "/.pagefile/pagefile";
      }
    ];

  nix.maxJobs = lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
}
