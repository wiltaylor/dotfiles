{
  description = "Wil Taylor's system configuration";

  inputs = {
    nixos.url = "nixpkgs/nixos-20.09";
    nixos-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-20.09";
    home-manager.inputs.nixpkgs.follows = "nixos";
    wtdevtools.url = "github:wiltaylor/wtdevtools";
  };

  outputs = inputs @ {self, nixos, nixos-unstable, home-manager, wtdevtools, nixpkgs, ... }:
  let
    inherit (nixos) lib;
    inherit (lib) attrValues;

    util = import ./lib/utility.nix { inherit system; };


    mkPkgs = pkgs: extraOverlays: import pkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = extraOverlays;
    };
    pkgs = mkPkgs nixos [ self.overlay ];
    upkgs = mkPkgs nixos-unstable [];

    system = "x86_64-linux";


    hst = import ./lib/host.nix { inherit system pkgs home-manager lib; };
    usr = import ./lib/user.nix { inherit pkgs home-manager; };

  in {
    overlay = 
      final: prev: {
        unstable = upkgs;
        my = self.packages."${system}";
      };

    packages."${system}" = import ./pkgs { inherit pkgs wtdevtools;};

    devShell."${system}" = import ./shell.nix { inherit pkgs; };

    nixosConfigurations = {
      titan = hst.mkHost {
        name = "titan";
        NICs = [ "enp62s0" "wlp63s0" ];
        initrdMods = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
        kernelMods = [" kvm-intel" ];
        roles = [ "sshd" "yubikey" "desktop-xorg" "games" "efi" "wifi" "nvidia-graphics" "core"];
        users = [ (usr.mkUser {
          name = "wil";
          groups = [ "wheel" "networkmanager" "libvirtd" "docker" ];
          uid = 1000;
          shell = "zsh";
          roles = [ "neovim" "git" "desktop/i3wm" "ranger" "tmux" "zsh" "email" ];
        })];
        cpuCores = 8;
      };

      mini = hst.mkHost {
        name = "mini";
        NICs = [ "wlo1" ];
        initrdMods = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
        kernelMods = [ "kvm-intel" ];
        roles = [ "sshd" "yubikey" "desktop-xorg" "efi" "wifi" "core" ];
        users = [ (usr.mkUser {
          name = "wil";
          groups = [ "wheel" "networkmanager" "libvirtd" "docker" ];
          uid = 1000;
          shell = "zsh";
          roles = [ "neovim" "git" "desktop/i3wm" "ranger" "tmux" "zsh" "email" ];
        })];
        cpuCores = 2;
      };      
    };
  };
}
