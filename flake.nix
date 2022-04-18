{
  description = "Wil Taylor's system configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    wks.url = "github:wiltaylor/nixwks";
    nixpkgs-overlay.url = "github:wiltaylor/nixpkgs-overlay";

    dev = {
      url = "github:wiltaylor/dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-flake = {
	    url = "github:wiltaylor/neovim-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {self, nixpkgs, neovim-flake, wks, nixpkgs-overlay, dev,  ... }:
  with builtins;
  let
    lib = import ./lib;

    allPkgs = lib.mkPkgs { 
      inherit nixpkgs; 
      cfg = { allowUnfree = true; };
      overlays = [
        #neovim-flake.overlay
        wks.overlay
        nixpkgs-overlay.overlay
        dev.overlay

        (self: last: {
          neovimWT = neovim-flake.packages."${self.system}".neovimWT; 
        })
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
          #sys.hotfix.CVE-2022-0847 = true;

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

          sys.kernelPackage = pkgs.linuxPackages_zen;
          sys.locale = "en_AU.UTF-8";
          sys.timeZone = "Australia/Brisbane";

          sys.users.primaryUser.extraGroups = [ "wheel" "networkmanager" "libvirtd" "docker" ];
          sys.virtualisation.vagrant.enable = false;
          sys.virtualisation.kvm.enable = true;
          sys.virtualisation.docker.enable = true;
          sys.virtualisation.appImage.enable = true;
          sys.virtualisation.virtualBox.enable = true;
          sys.cpu.type = "amd";
          sys.cpu.cores = 16;
          sys.cpu.threadsPerCore = 2;
          sys.cpu.sensorCommand = ''sensors | grep "Tdie" | awk '{print $2}' '';
          sys.biosType = "efi";
          sys.graphics.primaryGPU = "amd";
          sys.graphics.displayManager = "gdm";
          sys.graphics.desktopProtocols = [ "xorg" "wayland" ];
          sys.graphics.v4l2loopback = true;
          sys.graphics.gpuSensorCommand = ''sensors | grep "junction:" | awk '{print $2}' '';

          sys.audio.server = "pipewire";

          sys.hardware.g810led = true;
          sys.hardware.kindle = true;

          sys.security.yubikey = true;
          sys.security.username = "wil";
          sys.security.sshPublicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDkvWyA2elQ2e2c+dX2omY7ww0PdVtqwmmT0SX71r57zFiuuiXVrL0O5sGA83vKvJA+o9p9Wvu6dhRu/1Wth899OzZCBmNmJbiB5NWzzbbNxu1bEW24MYECxxTqSv9I8q62a39iPxZMbWZWRgKIegTHmA2A1SG/JEpGUcjw02dhT/ox95u07MFSW2J6ogJ65vM7APSSupTiPj57HRbWGTFG9uO6fn52ZOLod90uSOyypaTOVGho3yk2f9oUc3JXt8Qxd+e10rXMmIn7/msMWy4O8ybDAZxhCenuQtOwwx5id6A6G/RoR1TfAcvXX8E9zUj2qw6f3O1tZNL6/ooe+pHpug+8YhBjDr3rWQgsKXQnc7gyUNT6whrz5EA/RkZwP7z4cWNIVTVkKnmoG4RjmDbWW2q496fTXZZp+iv1JHoaeKqJ6G09RnmmrclWo02098TCYmRrcqbl6ggY7A/jMXQ1m/69y6eIYnq623hBQGIfy3i9qyNkaPq4R7bM3G8IuKo1bqzxhwjV/69UGWapyVrpGoB8WFZWE5GJHDM2aYPOCsS+26+y90Wao97K8/1FrR2ru/tHLfFCtR9lYNxMhS8ZJnW31rfP8ofpR/MCrPEklncxJg29FkSkXFaTBQQnF04oUEuf90YcMBUwh9H0dlTu3cnKIa+lg/h/52CTQOGN/Q==";

          sys.vfio.enable = true;
          sys.vfio.gpuType = "nvidia";
          sys.vfio.gpuPciIds = "10de:1e87,10de:10f8,10de:1ad8,10de:1ad9";
          sys.vfio.devIds = "0000:0c:00.0 0000:0c:00.1 0000:0c:00.2 0000:0c:00.3";

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

      mini = lib.mkNixOSConfig {
        name = "mini";
        system = "x86_64-linux";
        inherit nixpkgs allPkgs;
        cfg = let 
          pkgs = allPkgs.x86_64-linux;
        in {
          boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];

          networking.interfaces."wlo1" = { useDHCP = true; };
          networking.wireless.interfaces = [ "wol1" ];
          networking.networkmanager.enable = true;
          networking.useDHCP = false; 

          sys.locale = "en_AU.UTF-8";
          sys.timeZone = "Australia/Brisbane";

          sys.users.primaryUser.extraGroups = [ "wheel" "networkmanager" "libvirtd" "docker" "wil" ];

          sys.kernelPackage = pkgs.linuxPackages_5_10;
          sys.graphics.displayManager = "gdm";
          sys.graphics.desktopProtocols = [ "xorg" "wayland" ];
          sys.cpu.type = "intel";
          sys.cpu.cores = 2;
          sys.cpu.threadsPerCore = 2;
          sys.cpu.sensorCommand = ''sensors | grep "pch_cannonlake-virtual" -A 3 | grep "temp1" | awk '{print $2}' '';
          sys.biosType = "efi";
          sys.graphics.primaryGPU = "intel";
          sys.audio.server = "pipewire";
          sys.virtualisation.docker.enable = true;
          sys.virtualisation.appImage.enable = true;

          sys.desktop.kanshi.profiles = [
            {
              "eDP-1" = "position 0,0";
            }
          ];


          sys.virtualisation.kvm.enable = true;
          sys.bluetooth = true;
          #sys.wifi = true;

          sys.security.yubikey = true;
          sys.security.username = "wil";
          sys.security.sshPublicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC2u34uDlLjo6YfpgyvYTnhsUcmlANFdXEOo+jaM9R7DxNXjTVouMX06gwXvhtoKzbzqYf4OKBe+4xPA1rj/eBQenmCtzMLLCEy8JNDtx6KqdmrAZF9zlT71Y53Kl/EFFUDLEECcy6OmjkMDBLkxG6VhE3d3P39NbfXYa606dD0c6iGhZbj3iQK08Lz0Mt/S93/dQV6AfHtQDq0I/V5UwaA6vhpqFCkdqWWDxsew6IUxVXDFLLfb/ghYt4RND6c2xq2mqSwhZ9uVjUBdju0mZfgnQ616JkRGJANuE8BRUijp6LUswz1GYA7b0B7a0nKwk+VLoy6yYj8a+AX5XuREF70IeE2Kq85KmfRnumxMfAvLFDO0i9ACGyzmwFLP/tYyYyk9T4Ttdk8PM94BrlsHcFkZ3DcAtsx4H84KaWAsaZPVC+tBQFrTVS9HdJdi09L4N5+db4Cs1Fhwm69YXcSkQvNN61g3C5lYER7U7Wc4L7l1AlqxaEBdDURpGcpAjUvlRO+ZlTyUF/ZR3Qx24jMWtK3VkZdIkaV253v4TuZcDHwHub/9MnbUMydyTsp94n50WeKpAz/PHBHeB5KpE29DWNk8vmEQ134/t4S0hc6yL0vTGmlMLLOzqC0GNBBps+yamMI9xj6GVcic152+B2+mILRPC4LQu3u5nSCRaq2Qflh1Q==";
        };
      };
    };
  };
}
