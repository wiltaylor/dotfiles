{
  description = "Wil Taylor's system configuration";

  inputs = {
    nixos.url = "nixpkgs/nixos-20.09";
    nixos-unstable.url = "nixpkgs/nixos-unstable";
    nixos-master.url = "nixpkgs/master";
    home-manager.url = "github:nix-community/home-manager/release-20.09";
    home-manager.inputs.nixpkgs.follows = "nixos";
    wtdevtools.url = "github:wiltaylor/wtdevtools";
  };

  outputs = inputs @ {self, nixos, nixos-unstable, nixos-master, home-manager, wtdevtools, nixpkgs, ... }:
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

    packages."${system}" = import ./pkgs { inherit pkgs wtdevtools;};

    devShell."${system}" = import ./shell.nix { inherit pkgs; };

    installMedia = {
      i3 = host.mkISO {
        name = "nixos";
        kernelPackage = pkgs.unstable.linuxPackages_5_10;
        initrdMods = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "nvme" "usbhid" ];
        kernelMods = [ "kvm-intel" "kvm-amd" ];
        kernelParams = [ ];
        roles = [ "core" "i3wm" "user" ];
       
      };
    };

    nixosConfigurations = {
      titan = host.mkHost {
        name = "titan";
        NICs = [ "enp62s0" "wlp63s0" ];
        kernelPackage = pkgs.unstable.linuxPackages_5_10;
        initrdMods = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
        kernelMods = [" kvm-intel" ];
        kernelParams = ["intel_pstate=active" "nvme_core.default_ps_max_latency_us=0" ];
        roles = [ "sshd" "yubikey" "kvm" "desktop-xorg" "games" "efi" "wifi" "nvidia-graphics" "core" "alienware-amplifier"];
        users = [ (user.mkUser {
          name = "wil";
          groups = [ "wheel" "networkmanager" "libvirtd" "docker" ];
          uid = 1000;
          shell = "zsh";
          roles = [ "neovim" "git" "desktop/i3wm" "ranger" "tmux" "zsh" "email" ];
        })];
        cpuCores = 8;
      };

      mini = host.mkHost {
        name = "mini";
        NICs = [ "wlo1" ];
        kernelPackage = pkgs.linuxPackages_5_9;
        initrdMods = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
        kernelMods = [ "kvm-intel" ];
        kernelParams = [ "intel_pstate=active" ];
        roles = [ "sshd" "yubikey" "desktop-xorg" "efi" "wifi" "core" ];
        users = [ (user.mkUser {
          name = "wil";
          groups = [ "wheel" "networkmanager" "libvirtd" "docker" ];
          uid = 1000;
          shell = "zsh";
          roles = [ "neovim" "git" "desktop/i3wm" "ranger" "tmux" "zsh" "email" ];
        })];
        cpuCores = 2;
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
        users = [ (user.mkUser {
          name = "wil";
          groups = [ "wheel" "networkmanager" "libvirtd" "docker" ];
          uid = 1000;
          shell = "zsh";
          roles = [ "neovim" "git" "desktop/i3wm" "ranger" "tmux" "zsh" ];
        })];
      };
    };
  };
}
