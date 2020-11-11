{ pkgs, lib, config, ...}:
{
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/" =
    { device = "/dev/disk/by-label/ROOT";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-label/CRYPTROOT";

  fileSystems."/home" =
    { device = "/dev/disk/by-label/ROOT";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

  fileSystems."/var" =
    { device = "/dev/disk/by-label/ROOT";
      fsType = "btrfs";
      options = [ "subvol=@var" ];
    };

  fileSystems."/.pagefile" =
    { device = "/dev/disk/by-label/ROOT";
      fsType = "btrfs";
      options = [ "subvol=@pagefile" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };

  swapDevices = [ 
    {
      device = "/.pagefile/pagefile";
    }
  ]; 

}
