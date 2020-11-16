{pkgs, lib, config, home-manager, ...}:
{
  imports = [
    ../modules
    ../users
    ../.secret/wifi.nix
    ../roles/core.nix
    ../roles/sshd.nix
    ../roles/yubikey.nix
    ../roles/desktop-xorg.nix
    ../roles/games.nix
    ../roles/efi.nix
  ];

  #nixpkgs.overlays = overlay;
  #nixpkgs.overlays = [ (final: prev: {
  #  devtools = dts.defaultPackage.x86_64-linux;
  #})];

  environment.systemPackages = [ pkgs.my.devtools pkgs.microcodeIntel ];
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  
  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;

  # Networking
  networking.hostName = "titan";
  networking.interfaces.enp62s0.useDHCP = true;
#  networking.interfaces.wlp63s0.useDHCP = true;
  networking.firewall.allowedTCPPorts = [ ];
#  networking.wireless.enable = true;
  networking.networkmanager.enable = true;
  #networking.networkmanager.unmanaged = [
  #  "*" "except:type:wwan" "except:type:gsm"
 # ];
  networking.useDHCP = false; # Stop new devices auto connecting

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  nix.maxJobs = lib.mkDefault 8;
  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";

  services.xserver.videoDrivers = [ "nvidia" ];


  hardware.enableRedistributableFirmware = lib.mkDefault true;
  
}
