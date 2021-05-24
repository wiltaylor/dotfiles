{
  description = "Wil Taylor's system configuration";

  inputs = {
    nixos.url = "nixpkgs/nixos-unstable";
    nixos-unstable.url = "nixpkgs/nixos-unstable";
    nixos-master.url = "nixpkgs/master";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixos";

    flake-utils.url = github:numtide/flake-utils;

  };

  outputs = inputs @ {self, nixos, nixos-unstable, nixos-master, home-manager, nixpkgs, nur,  ... }:
  let
    inherit (nixos) lib;
    inherit (lib) attrValues;

    util = import ./lib { inherit system pkgs home-manager lib; overlays = (pkgs.overlays); };

    inherit (util) host;
    inherit (util) user;
    inherit (util) shell;
    #inherit (util) app;

    pkgs = import nixos {
      inherit system;
      config = { allowBroken = true; allowUnfree = true; };
      overlays = [
        #inputs.neovim-nightly-overlay.overlay
        #inputs.neovim-flake.overlay
        (final: prev: {
          unstable = import nixos-unstable {
            inherit system;
            config = { allowUnfree = true; };
          };

          master = import nixos-master {
            inherit system;
            config = { allowUnfree = true; };
          };

          my = import ./pkgs { inherit pkgs; };

          #Flake apps
          #neovimWT = app.mkFlakeApp { app = "github:wiltaylor/neovim-flake"; name = "vim"; };
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
        kernelPackage = pkgs.unstable.linuxPackages_5_11;
        initrdMods = [ "xhci_pci" "ahci" "nvme" "usbhid" "sd_mod" ];
        kernelMods = [ "kvm-amd" "it87" "k10temp" "nct6775" ];
        kernelParams = [];
        roles = [ "sshd" "kindle" "yubikey" "kvm" "desktop-xorg" "games" "efi" "amd-graphics" "core" "amd" "vfio" "datadrive" "sshd" ];
        users = [ {
          name = "wil";
          groups = [ "wheel" "networkmanager" "libvirtd" "docker" ];
          uid = 1000;
          shell = pkgs.zsh;
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
        }];
        laptop = true;
      };
    };
  };
}
