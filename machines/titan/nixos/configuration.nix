# Editthis configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ];

  # Make sure old crap is removed.
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 5d";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = import ./overlay;


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelModules = [ "kvm-intel" ];
  virtualisation.libvirtd.enable = true;

  networking.networkmanager.enable = true;
  networking.networkmanager.unmanaged = [
    "*" "except:type:wwan" "except:type:type:gsm"
  ];
  networking.hostName = "titan"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp62s0.useDHCP = true;
  networking.interfaces.wlp63s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Set your time zone.
  time.timeZone = "Australia/Brisbane";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
     wget 
     #(neovim.override  { vimAlias = true; })
     my.g810-led 
     gnupg
     yubikey-personalization
     yubioath-desktop
     killall
     bind
   ];

   # Yubikey settings
   services.udev.packages = [ pkgs.yubikey-personalization ];
   services.pcscd.enable = true;
   programs.gnupg.agent.pinentryFlavor = "curses";


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.xserver = {
    enable = true;

    videoDrivers = [ "nvidia" ];
  
    displayManager.lightdm.enable = true;
    displayManager.session = [
      {
        manage = "desktop";
        name = "xsession";
        start = "exec $HOME/.xsession";
      }
    ];

    displayManager.defaultSession = "xsession";
    displayManager.job.logToJournal = true;
    libinput.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.zsh.enable = true;
  programs.zsh.ohMyZsh.enable = true;

  users.users.wil= {
     isNormalUser = true;
     extraGroups = [ "wheel" "networkmanager" "libvirtd" ]; 
     uid = 1000;
     shell = pkgs.zsh; 
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
  
  security.sudo.extraConfig = "Defaults env_reset,timestamp_timeout=-1";



  # Setting up config for g810
  services.udev = {
    extraRules = ''
ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c336", MODE="666" RUN+="${pkgs.my.g810-led}/bin/g213-led -p ${pkgs.my.g810-led}/etc/g810-led/samples/group_keys"
ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c330", MODE="666" RUN+="${pkgs.my.g810-led}/bin/g410-led -p ${pkgs.my.g810-led}/etc/g810-led/samples/group_keys"
ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c33a", MODE="666" RUN+="${pkgs.my.g810-led}/bin/g413-led -p ${pkgs.my.g810-led}/etc/g810-led/samples/group_keys"
ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c342", MODE="666" RUN+="${pkgs.my.g810-led}/bin/g512-led -p ${pkgs.my.g810-led}/etc/g810-led/samples/group_keys"
ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c33c", MODE="666" RUN+="${pkgs.my.g810-led}/bin/g513-led -p ${pkgs.my.g810-led}/etc/g810-led/samples/group_keys"
ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c333", MODE="666" RUN+="${pkgs.my.g810-led}/bin/g610-led -p ${pkgs.my.g810-led}/etc/g810-led/samples/group_keys"
ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c338", MODE="666" RUN+="${pkgs.my.g810-led}/bin/g610-led -p ${pkgs.my.g810-led}/etc/g810-led/samples/group_keys"
ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c331", MODE="666" RUN+="${pkgs.my.g810-led}/bin/g810-led -p ${pkgs.my.g810-led}/etc/g810-led/samples/group_keys"
ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c337", MODE="666" RUN+="${pkgs.my.g810-led}/bin/g810-led -p ${pkgs.my.g810-led}/etc/g810-led/samples/group_keys"
ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c33f", MODE="666" RUN+="${pkgs.my.g810-led}/bin/g815-led -p ${pkgs.my.g810-led}/etc/g810-led/samples/group_keys"
ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c32b", MODE="666" RUN+="${pkgs.my.g810-led}/bin/g910-led -p ${pkgs.my.g810-led}/etc/g810-led/samples/group_keys"
ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c335", MODE="666" RUN+="${pkgs.my.g810-led}/bin/g910-led -p ${pkgs.my.g810-led}/etc/g810-led/samples/group_keys"
ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c339", MODE="666" RUN+="${pkgs.my.g810-led}/bin/gpro-led -p ${pkgs.my.g810-led}/etc/g810-led/samples/group_keys"
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c336", MODE="666" RUN+="${pkgs.my.g810-led}/bin/g213-led -p ${pkgs.my.g810-led}/etc/g810-led/samples/group_keys"
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c330", MODE="666" RUN+="${pkgs.my.g810-led}/bin/g410-led -p ${pkgs.my.g810-led}/etc/g810-led/samples/group_keys"
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c33a", MODE="666" RUN+="${pkgs.my.g810-led}/bin/g413-led -p ${pkgs.my.g810-led}/etc/g810-led/samples/group_keys"
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c342", MODE="666" RUN+="${pkgs.my.g810-led}/bin/g512-led -p ${pkgs.my.g810-led}/etc/g810-led/samples/group_keys"
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c33c", MODE="666" RUN+="${pkgs.my.g810-led}/bin/g513-led -p ${pkgs.my.g810-led}/etc/g810-led/samples/group_keys"
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c333", MODE="666" RUN+="${pkgs.my.g810-led}/bin/g610-led -p ${pkgs.my.g810-led}/etc/g810-led/samples/group_keys"
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c338", MODE="666" RUN+="${pkgs.my.g810-led}/bin/g610-led -p ${pkgs.my.g810-led}/etc/g810-led/samples/group_keys"
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c331", MODE="666" RUN+="${pkgs.my.g810-led}/bin/g810-led -p ${pkgs.my.g810-led}/etc/g810-led/samples/group_keys"
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c337", MODE="666" RUN+="${pkgs.my.g810-led}/bin/g810-led -p ${pkgs.my.g810-led}/etc/g810-led/samples/group_keys"
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c32b", MODE="666" RUN+="${pkgs.my.g810-led}/bin/g910-led -p ${pkgs.my.g810-led}/etc/g810-led/samples/group_keys"
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c335", MODE="666" RUN+="${pkgs.my.g810-led}/bin/g910-led -p ${pkgs.my.g810-led}/etc/g810-led/samples/group_keys"
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c339", MODE="666" RUN+="${pkgs.my.g810-led}/bin/gpro-led -p ${pkgs.my.g810-led}/etc/g810-led/samples/group_keys"
    '';
  };

  systemd.services.g810-led = {
    description = "Set Logitech G810 Led Profile";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.my.g810-led}/bin/g810-led -p ${pkgs.my.g810-led}/etc/g810-led/samples/group_keys";
      Type = "oneshot";
      RemainAfterExit = "yes";
    };
  };

  systemd.services.g810-led-reboot = {
    description = "Set G810 profile on shutown";
    wantedBy = [ "shutdown.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = "${pkgs.my.g810-led}/bin/g810-led -p ${pkgs.my.g810-led}/etc/g810-led/sampels/all_off";
      Before = ["shutdown.target" "reboot.target" "halt.target" ];
      DefaultDependencies = "no";
    };
  };


  environment.etc = {
    "/etc/g810-led/group_keys".source = "${pkgs.my.g810-led}/etc/g810-led/samples/group_keys";
    "/etc/g810-led/reboot".source = "${pkgs.my.g810-led}/etc/g810-led/sampels/all_off";
  };

}

