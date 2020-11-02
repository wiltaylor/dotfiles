{pkgs, lib, config, home-manager, ...}:
{
  imports = [
    ../modules
    ../users
    ../.secret/wifi.nix
    ../roles/core.nix
    ../roles/sshd.nix
    ../roles/yubikey.nix
    ../roles/desktop-xorg.nix
    ../roles/games.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  
  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;

  # Networking
  networking.hostName = "titan";
  networking.interfaces.enp62s0.useDHCP = true;
#  networking.interfaces.wlp63s0.useDHCP = true;
  networking.firewall.allowedTCPPorts = [ ];
#  networking.wireless.enable = true;
  networking.networkmanager.enable = true;
  networking.networkmanager.unmanaged = [
    "*" "except:type:wwan" "except:type:gsm"
  ];
  networking.useDHCP = false; # Stop new devices auto connecting

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  nix.maxJobs = lib.mkDefault 8;
  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
  
  # System specific disk layout options
  #TODO: Use labels so this can be more generic across laptops.

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
}
