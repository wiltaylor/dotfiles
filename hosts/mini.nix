{pkgs, lib, config, ...}:
{
  imports = [
    ../modules
    ../users
    ../.secret/wifi.nix
    ../roles/core.nix
    ../roles/sshd.nix
    ../roles/yubikey.nix
    ../roles/desktop-xorg.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  
  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;

  # Networking
  networking.hostName = "mini";
  networking.interfaces.wlo1.useDHCP = true;
  networking.firewall.allowedTCPPorts = [ ];
  networking.wireless.enable = true;
  networking.networkmanager.enable = true;
  networking.networkmanager.unmanaged = [
    "*" "except:type:wwan" "except:type:gsm"
  ];

  hardware.bluetooth.enable = true;
  
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  
  # System specific disk layout options
  #TODO: Use labels so this can be more generic across laptops.

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/0d20ff14-1f0a-45eb-aae6-22bd288da254";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

  fileSystems."/var" =
    { device = "/dev/disk/by-uuid/0d20ff14-1f0a-45eb-aae6-22bd288da254";
      fsType = "btrfs";
      options = [ "subvol=@var" ];
    };

  fileSystems."/.snapshots" =
    { device = "/dev/disk/by-uuid/0d20ff14-1f0a-45eb-aae6-22bd288da254";
      fsType = "btrfs";
      options = [ "subvol=@snapshots" ];
    };

  fileSystems."/.pagefile" =
    { device = "/dev/disk/by-uuid/0d20ff14-1f0a-45eb-aae6-22bd288da254";
      fsType = "btrfs";
      options = [ "subvol=@pagefile" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/5842-CFF5";
      fsType = "vfat";
    };

    swapDevices = [ 
      {
        device = "/.pagefile/pagefile";
        size = 2048;
      }
    ];

}
