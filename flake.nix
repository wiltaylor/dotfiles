{
  description = "Wil Taylor's system configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {self, nixpkgs, ... }:
  with builtins;
  let
    lib = import ./lib;
    localpkgs = import ./pkgs;
    extralib = self: super: import ./lib/extrafn.nix {pkgs = super;};

    allPkgs = lib.mkPkgs { 
      inherit nixpkgs; 
      cfg = { allowUnfree = true; };
      overlays = [
        localpkgs
        extralib
      ];
    };

  in {
    devShell = lib.withDefaultSystems (sys: let
      pkgs = allPkgs."${sys}";
    in import ./shell.nix { inherit pkgs; });

    packages = lib.mkSearchablePackages allPkgs;

    nixosConfigurations = {
      titan = lib.mkNixOSConfig {
        name = "titan";
        system = "x86_64-linux";
        inherit nixpkgs allPkgs;
        cfg = let 
          pkgs = allPkgs.x86_64-linux;
        in {
          boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "sd_mod" ];
          boot.kernelModules = [ "it87" "k10temp" "nct6775" ];

          services.xserver.displayManager.defaultSession = "sway";

          sys.hotfix.kernelVectorWarning = true; 

          networking.interfaces."enp5s0" = { useDHCP = true; };
          networking.networkmanager.enable = true;
          networking.useDHCP = false; 

          sys.desktop.kanshi.profiles = [
            { 
              "DP-2" = "position 0,0";
              "HDMI-A-1" = "position 3840,0";
              "DP-1" = "position 7680,0";
            }

            { 
              "DP-1" = "position 0,0";
            }
          ];


          sys.user.users.wil = {
              groups = [ "wheel" "networkmanager" "libvirtd" "docker" "wil" ];
              roles = [
                "development" 
                "productivity" 
                "games"
              ];
              
              sshPublicKeys = [ 
                "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC2u34uDlLjo6YfpgyvYTnhsUcmlANFdXEOo+jaM9R7DxNXjTVouMX06gwXvhtoKzbzqYf4OKBe+4xPA1rj/eBQenmCtzMLLCEy8JNDtx6KqdmrAZF9zlT71Y53Kl/EFFUDLEECcy6OmjkMDBLkxG6VhE3d3P39NbfXYa606dD0c6iGhZbj3iQK08Lz0Mt/S93/dQV6AfHtQDq0I/V5UwaA6vhpqFCkdqWWDxsew6IUxVXDFLLfb/ghYt4RND6c2xq2mqSwhZ9uVjUBdju0mZfgnQ616JkRGJANuE8BRUijp6LUswz1GYA7b0B7a0nKwk+VLoy6yYj8a+AX5XuREF70IeE2Kq85KmfRnumxMfAvLFDO0i9ACGyzmwFLP/tYyYyk9T4Ttdk8PM94BrlsHcFkZ3DcAtsx4H84KaWAsaZPVC+tBQFrTVS9HdJdi09L4N5+db4Cs1Fhwm69YXcSkQvNN61g3C5lYER7U7Wc4L7l1AlqxaEBdDURpGcpAjUvlRO+ZlTyUF/ZR3Qx24jMWtK3VkZdIkaV253v4TuZcDHwHub/9MnbUMydyTsp94n50WeKpAz/PHBHeB5KpE29DWNk8vmEQ134/t4S0hc6yL0vTGmlMLLOzqC0GNBBps+yamMI9xj6GVcic152+B2+mILRPC4LQu3u5nSCRaq2Qflh1Q=="
              ];

              config = {
                email = "email@wiltaylor.dev";
                name = "Wil Taylor";
                signingKey = "0xB6840C8AFFAD67EC";
              };
          };


          sys.kernelPackage = pkgs.linuxPackages_zen;

          sys.cpu.type = "amd";
          sys.cpu.cores = 16;
          sys.cpu.threadsPerCore = 2;
          sys.cpu.sensorCommand = ''sensors | grep "Tctl:" | awk '{print $2}' '';
          sys.biosType = "efi";
          sys.hardware.graphics.primaryGPU = "amd";
          sys.hardware.graphics.displayManager = "gdm";
          sys.hardware.graphics.desktopProtocols = [ "xorg" "wayland" ];
          sys.hardware.graphics.v4l2loopback = true;
          sys.hardware.graphics.gpuSensorCommand = ''sensors | grep "junction:" | awk '{print $2}' '';

          sys.hardware.audio.server = "pipewire";
          sys.hardware.g810led = true;
          sys.hardware.kindle = true;

          sys.security.yubikey = true;

          #sys.hardware.vfio.enable = true;
          #sys.hardware.vfio.gpuType = "nvidia";
          #sys.hardware.vfio.gpuPciIds = "10de:1e87,10de:10f8,10de:1ad8,10de:1ad9";
          #sys.hardware.vfio.devIds = "0000:0c:00.0 0000:0c:00.1 0000:0c:00.2 0000:0c:00.3";

          ## Extra mapped disk drives
          boot.initrd.luks.devices."datacrypt".device = "/dev/disk/by-label/DATACRYPT";
          boot.initrd.luks.devices."vmcrypt".device = "/dev/disk/by-label/VMCRYPT";

          fileSystems."/data" = {
            device = "/dev/disk/by-label/DATADISK";
            fsType = "btrfs";
            options = [ "subvol=@" ];
          };

          fileSystems."/vmstore" = 
          {
            device = "/dev/disk/by-label/VMSTORE";
            fsType = "btrfs";
            options = [ "subvol=@" ];
          };
        };
      };

      zeus = lib.mkNixOSConfig {
        name = "zeus";
        system = "x86_64-linux";
        inherit nixpkgs allPkgs;

        cfg = let 
          pkgs = allPkgs.x86_64-linux;
        in {
          boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];

          networking.interfaces."wlp164s0" = { useDHCP = true; };
          networking.wireless.interfaces = [ "wlp164s0" ];
          networking.networkmanager.enable = true;
          networking.useDHCP = false; 

          sys.user.users.wil = {
              groups = [ "wheel" "networkmanager" "libvirtd" "docker" "wil" ];
              roles = [
                "development" 
                "productivity" 
                "games"
              ];
              
              sshPublicKeys = [ 
                "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC2u34uDlLjo6YfpgyvYTnhsUcmlANFdXEOo+jaM9R7DxNXjTVouMX06gwXvhtoKzbzqYf4OKBe+4xPA1rj/eBQenmCtzMLLCEy8JNDtx6KqdmrAZF9zlT71Y53Kl/EFFUDLEECcy6OmjkMDBLkxG6VhE3d3P39NbfXYa606dD0c6iGhZbj3iQK08Lz0Mt/S93/dQV6AfHtQDq0I/V5UwaA6vhpqFCkdqWWDxsew6IUxVXDFLLfb/ghYt4RND6c2xq2mqSwhZ9uVjUBdju0mZfgnQ616JkRGJANuE8BRUijp6LUswz1GYA7b0B7a0nKwk+VLoy6yYj8a+AX5XuREF70IeE2Kq85KmfRnumxMfAvLFDO0i9ACGyzmwFLP/tYyYyk9T4Ttdk8PM94BrlsHcFkZ3DcAtsx4H84KaWAsaZPVC+tBQFrTVS9HdJdi09L4N5+db4Cs1Fhwm69YXcSkQvNN61g3C5lYER7U7Wc4L7l1AlqxaEBdDURpGcpAjUvlRO+ZlTyUF/ZR3Qx24jMWtK3VkZdIkaV253v4TuZcDHwHub/9MnbUMydyTsp94n50WeKpAz/PHBHeB5KpE29DWNk8vmEQ134/t4S0hc6yL0vTGmlMLLOzqC0GNBBps+yamMI9xj6GVcic152+B2+mILRPC4LQu3u5nSCRaq2Qflh1Q=="
              ];

              config = {
                email = "email@wiltaylor.dev";
                name = "Wil Taylor";
                signingKey = "0xB6840C8AFFAD67EC";
              };
          };

          sys.hardware.graphics.displayManager = "gdm";
          sys.hardware.graphics.desktopProtocols = [ "xorg" "wayland" ];
          sys.cpu.type = "intel";
          sys.cpu.cores = 4;
          sys.cpu.threadsPerCore = 2;
          sys.cpu.sensorCommand = ''sensors | grep "Package id 0:" | awk '{print $4}' | sed 's/+//' '';
          sys.biosType = "efi";
          sys.hardware.graphics.primaryGPU = "intel";

          sys.hardware.graphics.gpuSensorCommand = ''sensors | grep "pch_cannonlake-virtual" -A 3 | grep "temp1" | awk '{print $2}' '';
          sys.hardware.audio.server = "pipewire";
          sys.virtualisation.docker.enable = true;
          
          sys.desktop.kanshi.profiles = [
            {
              "eDP-1" = "position 0,0";
            }
          ];

          sys.hardware.bluetooth = true;

          sys.security.yubikey = true;
        };
      };
    };
  };
}
