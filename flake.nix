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
        roles = ["sshd" "kindle" "yubikey" "desktop-xorg" "games" "core" "sshd" "v4l2loopback" ];
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
          sys.cpu.type = "amd";
          sys.cpu.cores = 16;
          sys.cpu.threadsPerCore = 2;
          sys.biosType = "efi";
          sys.graphics.primaryGPU = "amd";
          sys.graphics.displayManager = "lightdm";
          sys.graphics.desktopProtocols = [ "xorg" ];
          sys.audio.server = "pulse";
          sys.hardware.g810led = true;

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
        roles = [ "sshd" "yubikey" "desktop-xorg" "wifi" "core" "sshd" ];
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
          sys.bluetooth = true;

        };
      };
    };
  };
}
