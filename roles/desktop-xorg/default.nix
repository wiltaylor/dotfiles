{config, pkgs, lib, ...}:
{
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  hardware.g810led.enable = true;
#  services.accounts-daemon.enable = true;
  boot.plymouth.enable = true;
  services.autorandr.enable = true;

  services.xserver = {
    enable = true;
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

  environment.systemPackages = with pkgs; [
    appimage-run
    lightdm
    dfeet

    (pkgs.writeScriptBin "desktop" ''
      #!${pkgs.bash}/bin/bash

      case $1 in
      "wallpaper")
        ${pkgs.feh}/bin/feh --bg-fill --randomize ~/.config/wallpapers/*
      ;;
      *)
        echo "Usage:"
        echo "desktop command"
        echo ""
        echo "Commands:"
        echo "wallpaper - randomly selects new wallpapers"
      ;;
      esac

    '')
  ];

  services.gnome3.gnome-keyring.enable = true;
  services.accounts-daemon.enable = true;
  environment.pathsToLink = [ "/share/accountsservice" ];
}
