{
  description = "Wil Taylor's system configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    kn.url = "github:wiltaylor/kn";

    neovim-flake = {
	url = "github:wiltaylor/neovim-flake";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.flake-utils.follows = "flake-utils";
    };

    flake-utils.url = "github:numtide/flake-utils";

  };

  outputs = inputs @ {self, nixpkgs, home-manager, kn, neovim-flake, ... }:
  let
    inherit (nixpkgs) lib;
    inherit (lib) attrValues;

    util = import ./lib { inherit system pkgs home-manager lib; overlays = (pkgs.overlays); };

    inherit (util) host;
    inherit (util) user;
    inherit (util) shell;
    inherit (util) app;

    pkgs = import nixpkgs {
      inherit system;
      config = { allowBroken = true; allowUnfree = true; };
      overlays = [
        kn.overlay
        neovim-flake.overlay."${system}"
        (final: prev: {
          my = import ./pkgs { inherit pkgs; };
        })
      ];
    };

    system = "x86_64-linux";

  in {
    shells = {
      video = shell.mkShell {
        name = "video";
        buildInputs = with pkgs; [ blender obs-studio obs-v4l2sink mpv youtube-dl audacity ffmpeg ];
        script = ''
          echo "Video editing shell"
        '';
      };
    };

    packages."${system}" = pkgs;
    devShell."${system}" = import ./shell.nix { inherit pkgs; };

    installMedia = {
      i3 = host.mkISO {
        name = "nixos";
        kernelPackage = pkgs.unstable.linuxPackages_5_10;
        initrdMods = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "nvme" "usbhid" ];
        kernelMods = [ "kvm-intel" "kvm-amd" ];
        kernelParams = [ ];
        roles = [ "core" "i3wm" "user" "yubikey" "amd-graphics" ];
      };
    };

    homeManagerConfigurations = {
      wil = user.mkHMUser { 
        roles = [ "git" "desktop/i3wm" "ranger" "tmux" "zsh" "email" ];
        username = "wil";
      };
    };

    nixosConfigurations = {
      titan = host.mkHost {
        name = "titan";
        NICs = [ "enp5s0" ];
        initrdMods = [ "xhci_pci" "ahci" "nvme" "usbhid" "sd_mod" ];
        kernelMods = [ "it87" "k10temp" "nct6775" ];
        kernelParams = [];
        roles = ["games" "core" ];
        users = [ {
          name = "wil";
          groups = [ "wheel" "networkmanager" "libvirtd" "docker" ];
          uid = 1000;
          shell = pkgs.zsh;
        }];
        laptop = false;
        gpuTempSensor = ''sensors | grep "junction:" | awk '{print $2}' '';
        cpuTempSensor = ''sensors | grep "Tdie" | awk '{print $2}' '';
        
        cfg = {
          sys.locale = "en_AU.UTF-8";
          sys.timeZone = "Australia/Brisbane";

          sys.virtualisation.vagrant.enable = true;
          sys.virtualisation.kvm.enable = true;
          sys.virtualisation.docker.enable = true;
          sys.virtualisation.flatpak.enable = true;
          sys.virtualisation.appImage.enable = true;
          sys.cpu.type = "amd";
          sys.cpu.cores = 16;
          sys.cpu.threadsPerCore = 2;
          sys.biosType = "efi";
          sys.graphics.primaryGPU = "amd";
          sys.graphics.displayManager = "lightdm";
          sys.graphics.desktopProtocols = [ "xorg" ];
          sys.graphics.v4l2loopback = true;
          sys.audio.server = "pulse";
          sys.hardware.g810led = true;
          sys.hardware.kindle = true;

          sys.security.yubikey = true;
          sys.security.username = "wil";
          sys.security.sshPublicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC2u34uDlLjo6YfpgyvYTnhsUcmlANFdXEOo+jaM9R7DxNXjTVouMX06gwXvhtoKzbzqYf4OKBe+4xPA1rj/eBQenmCtzMLLCEy8JNDtx6KqdmrAZF9zlT71Y53Kl/EFFUDLEECcy6OmjkMDBLkxG6VhE3d3P39NbfXYa606dD0c6iGhZbj3iQK08Lz0Mt/S93/dQV6AfHtQDq0I/V5UwaA6vhpqFCkdqWWDxsew6IUxVXDFLLfb/ghYt4RND6c2xq2mqSwhZ9uVjUBdju0mZfgnQ616JkRGJANuE8BRUijp6LUswz1GYA7b0B7a0nKwk+VLoy6yYj8a+AX5XuREF70IeE2Kq85KmfRnumxMfAvLFDO0i9ACGyzmwFLP/tYyYyk9T4Ttdk8PM94BrlsHcFkZ3DcAtsx4H84KaWAsaZPVC+tBQFrTVS9HdJdi09L4N5+db4Cs1Fhwm69YXcSkQvNN61g3C5lYER7U7Wc4L7l1AlqxaEBdDURpGcpAjUvlRO+ZlTyUF/ZR3Qx24jMWtK3VkZdIkaV253v4TuZcDHwHub/9MnbUMydyTsp94n50WeKpAz/PHBHeB5KpE29DWNk8vmEQ134/t4S0hc6yL0vTGmlMLLOzqC0GNBBps+yamMI9xj6GVcic152+B2+mILRPC4LQu3u5nSCRaq2Qflh1Q==";

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

      mini = host.mkHost {
        name = "mini";
        NICs = [ "wlo1" ];
        initrdMods = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
        kernelMods = [ ];
        kernelParams = [ ];
        roles = [ "wifi" "core" ];
        users = [ {
          name = "wil";
          groups = [ "wheel" "networkmanager" "libvirtd" "docker" "wil" ];
          uid = 1000;
          shell = pkgs.zsh;
        }];
        laptop = true;
        wifi = [ "wlo1" ];
        cpuTempSensor = ''sensors | grep "pch_cannonlake-virtual" -A 3 | grep "temp1" | awk '{print $2}' '';
        cfg = {
          sys.locale = "en_AU.UTF-8";
          sys.timeZone = "Australia/Brisbane";

          sys.kernelPackage = pkgs.linuxPackages_5_10;
          sys.graphics.displayManager = "lightdm";
          sys.graphics.desktopProtocol = [ "xorg" ];
          sys.cpu.type = "intel";
          sys.cpu.cores = 2;
          sys.cpu.threadsPerCore = 2;
          sys.biosType = "efi";
          sys.graphics.primaryGPU = "intel";
          sys.audio.server = "pulse";
          sys.virtualisation.kvm = true;
          sys.virtualisation.docker.enable = true;
          sys.virtualisation.appImage.enable = true;
          sys.bluetooth = true;

          sys.security.yubikey = true;
          sys.security.username = "wil";
          sys.security.sshPublicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC2u34uDlLjo6YfpgyvYTnhsUcmlANFdXEOo+jaM9R7DxNXjTVouMX06gwXvhtoKzbzqYf4OKBe+4xPA1rj/eBQenmCtzMLLCEy8JNDtx6KqdmrAZF9zlT71Y53Kl/EFFUDLEECcy6OmjkMDBLkxG6VhE3d3P39NbfXYa606dD0c6iGhZbj3iQK08Lz0Mt/S93/dQV6AfHtQDq0I/V5UwaA6vhpqFCkdqWWDxsew6IUxVXDFLLfb/ghYt4RND6c2xq2mqSwhZ9uVjUBdju0mZfgnQ616JkRGJANuE8BRUijp6LUswz1GYA7b0B7a0nKwk+VLoy6yYj8a+AX5XuREF70IeE2Kq85KmfRnumxMfAvLFDO0i9ACGyzmwFLP/tYyYyk9T4Ttdk8PM94BrlsHcFkZ3DcAtsx4H84KaWAsaZPVC+tBQFrTVS9HdJdi09L4N5+db4Cs1Fhwm69YXcSkQvNN61g3C5lYER7U7Wc4L7l1AlqxaEBdDURpGcpAjUvlRO+ZlTyUF/ZR3Qx24jMWtK3VkZdIkaV253v4TuZcDHwHub/9MnbUMydyTsp94n50WeKpAz/PHBHeB5KpE29DWNk8vmEQ134/t4S0hc6yL0vTGmlMLLOzqC0GNBBps+yamMI9xj6GVcic152+B2+mILRPC4LQu3u5nSCRaq2Qflh1Q==";



        };
      };
    };
  };
}
