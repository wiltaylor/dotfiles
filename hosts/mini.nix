{pkgs, lib, config, ...}:
{
  imports = [
    ../modules
    ../users
    ../.secret/wifi.nix
    ../roles/core.nix
    ../roles/sshd.nix
    ../roles/yubikey.nix
    ../roles/desktop-xorg.nix
    ../roles/efi.nix
  ];

  nixpkgs.overlays = [ (final: prev: {
    devtools = dts.defaultPackage.x86_64-linux;
  })];

  environment.systemPackages = [ pkgs.devtools pkgs.microcodeIntel ];
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  
  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;

  # Networking
  networking.hostName = "mini";
  networking.interfaces.wlo1.useDHCP = true;
  networking.firewall.allowedTCPPorts = [ ];
  networking.wireless.enable = true;
  networking.networkmanager.enable = true;
  networking.networkmanager.unmanaged = [
    "*" "except:type:wwan" "except:type:gsm"
  ];

  hardware.bluetooth.enable = true;

  networking.useDHCP = false; # Stop new devices auto connecting
  
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  
}
