{
  description = "Wil Taylor's system configuration";

  inputs = {
    nixos.url = "nixpkgs/nixos-unstable";
    nixos-unstable.url = "nixpkgs/nixos-unstable";
    nixos-master.url = "nixpkgs/master";
    home-manager.url = "github:nix-community/home-manager/release-20.09";
    home-manager.inputs.nixpkgs.follows = "nixos";
  };

  outputs = inputs @ {self, nixos, nixos-unstable, nixos-master, home-manager, nixpkgs, ... }:
  let
    inherit (nixos) lib;
    inherit (lib) attrValues;

    util = import ./lib { inherit system pkgs home-manager lib; };

    inherit (util) host;
    inherit (util) user;

    mkPkgs = pkgs: extraOverlays: import pkgs {
      inherit system;
      config.allowUnfree = true;
      config.allowBroken = true;
      overlays = extraOverlays;
    };

    pkgs = mkPkgs nixos [ self.overlay ];
    upkgs = mkPkgs nixos-unstable [];
    mpkgs = mkPkgs nixos-master [];

    system = "x86_64-linux";

  in {
    overlay = 
      final: prev: {
        unstable = upkgs;
        master = mpkgs;
        my = self.packages."${system}";
      };

    packages."${system}" = import ./pkgs { inherit pkgs;};

    devShell."${system}" = import ./shell.nix { inherit pkgs; };

    installMedia = {
      i3 = host.mkISO {
        name = "nixos";
        kernelPackage = pkgs.unstable.linuxPackages_5_10;
        initrdMods = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "nvme" "usbhid" ];
        kernelMods = [ "kvm-intel" "kvm-amd" ];
        kernelParams = [ ];
        roles = [ "core" "i3wm" "user" "yubikey" ];       
      };
    };

    nixosConfigurations = {
      titan = host.mkHost {
        name = "titan";
        NICs = [ "enp5s0" ];
        kernelPackage = pkgs.unstable.linuxPackages_5_10;
        initrdMods = [ "xhci_pci" "ahci" "nvme" "usbhid" "sd_mod" ];
        kernelMods = [ "kvm-amd" "it87" "k10temp" "nct6775" ];
        kernelParams = [];
        roles = [ "sshd" "yubikey" "kvm" "desktop-xorg" "games" "efi" "amd-graphics" "core" "amd" "vfio" "datadrive" ];
        users = [ {
          name = "wil";
          groups = [ "wheel" "networkmanager" "libvirtd" "docker" ];
          uid = 1000;
          shell = pkgs.zsh;
          roles = [ "neovim" "git" "desktop/i3wm" "ranger" "tmux" "zsh" "email" ];
          data = {};
        }];
        cpuCores = 8;
        laptop = false;
      };

      mini = host.mkHost {
        name = "mini";
        NICs = [ "wlo1" ];
        kernelPackage = pkgs.linuxPackages_5_10;
        initrdMods = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
        kernelMods = [ "kvm-intel" ];
        kernelParams = [ "intel_pstate=active" ];
        roles = [ "sshd" "yubikey" "desktop-xorg" "efi" "wifi" "core" ];
        users = [ {
          name = "wil";
          groups = [ "wheel" "networkmanager" "libvirtd" "docker" "wil" ];
          uid = 1000;
          shell = pkgs.zsh;
          roles = [ "neovim" "git" "desktop/i3wm" "ranger" "tmux" "zsh" ];
          data = {};
        }];
        cpuCores = 2;
        laptop = true;
      };   

      junkbox = host.mkHost {
        name = "junkbox";
        NICs = [];
        kernelPackage = pkgs.linuxPackages_5_9;
        initrdMods = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
        kernelMods = [ "kvm-intel" ];
        kernelParams = [];
        roles = [ "sshd" "yubikey" "desktop-xorg" "efi" "wifi" "core" ];
        cpuCores = 4;
        users = [ {
          name = "wil";
          groups = [ "wheel" "networkmanager" "libvirtd" "docker" ];
          uid = 1000;
          shell = pkgs.zsh;
          roles = [ "neovim" "git" "desktop/i3wm" "ranger" "tmux" "zsh" ];
          data = {};
        }];
        laptop = true;
      };
    };
  };
}
