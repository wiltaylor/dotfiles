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
  ];

  services.gnome3.gnome-keyring.enable = true;
}
