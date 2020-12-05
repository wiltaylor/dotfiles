{config, pkgs, lib, ...}:
{
  system.stateVersion = "20.09";

  nix = {
    extraOptions = "experimental-features = nix-command flakes";
    gc = {
      automatic = true;
      options = "--delete-older-than 5d";
    };

  };

  i18n.defaultLocale = "en_AU.UTF-8";
  time.timeZone = "Australia/Brisbane";
  services.earlyoom.enable = true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  

  environment.systemPackages = with pkgs; [
    wget
    pciutils
    curl
    bind
    killall
    dmidecode
    neofetch
    htop
    bat
    unzip
    file
    zip
    p7zip
    ranger
    strace
    ltrace
    git
    git-crypt
    tmux
    zsh
    dmg2img
    unrar
    python3
    nix-bundle
    my.devtools 
    microcodeIntel
    imagemagick
    pstree
    linuxPackages_5_9.bcc
  ];

  security.sudo.extraConfig = "Defaults env_reset,timestamp_timeout=-1";
}
