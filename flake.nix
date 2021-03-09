{
  description = "Wil Taylor's system configuration";

  inputs = {
    nixos.url = "nixpkgs/nixos-unstable";
    nixos-unstable.url = "nixpkgs/nixos-unstable";
    nixos-master.url = "nixpkgs/master";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixos";
    nur.url = "github:nix-community/NUR";

    flake-utils.url = github:numtide/flake-utils;
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";


  };

  outputs = inputs @ {self, nixos, nixos-unstable, nixos-master, home-manager, nixpkgs, nur, ... }:
  let
    inherit (nixos) lib;
    inherit (lib) attrValues;

    util = import ./lib { inherit system pkgs home-manager lib; };

    inherit (util) host;
    inherit (util) user;
    inherit (util) shell;

    pkgs = import nixos {
      inherit system;
      config = { allowBroken = true; allowUnfree = true; };
      overlays = [
        inputs.neovim-nightly-overlay.overlay
        (final: prev: {
          unstable = import nixos-unstable {
            inherit system;
            config = { allowUnfree = true; };
          };

          master = import nixos-master {
            inherit system;
            config = { allowUnfree = true; };
          };

          nur = import nur {
            inherit system;
            config = { allowUnfree = true; };
          };

          my = import ./pkgs { inherit pkgs; };
        })
      ];
    };

    system = "x86_64-linux";

  in {
    shells = {
      video = shell.mkShell {
        name = "video";
        buildInputs = with pkgs; [ blender obs-studio obs-v4l2sink mpv ];
        script = ''
          echo "Video editing shell"
        '';
      };
    };

    packages."${system}" = pkgs;
#    nur = nur;

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

    nixosConfigurations = {
      titan = host.mkHost {
        name = "titan";
        NICs = [ "enp5s0" ];
        kernelPackage = pkgs.unstable.linuxPackages_5_10;
        initrdMods = [ "xhci_pci" "ahci" "nvme" "usbhid" "sd_mod" ];
        kernelMods = [ "kvm-amd" "it87" "k10temp" "nct6775" ];
        kernelParams = [];
        roles = [ "sshd" "yubikey" "kvm" "desktop-xorg" "games" "efi" "amd-graphics" "core" "amd" "vfio" "datadrive" "sshd" ];
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
        roles = [ "sshd" "yubikey" "desktop-xorg" "efi" "wifi" "core" "bluetooth" "sshd" ];
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
