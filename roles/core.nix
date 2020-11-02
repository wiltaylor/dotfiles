{config, pkgs, lib, ...}:
{
  system.stateVersion = "20.09";

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = "experimental-features = nix-command flakes";
    gc = {
      automatic = true;
      options = "--delete-older-than 5d";
    };
  };

  i18n.defaultLocale = "en_AU.UTF-8";
  time.timeZone = "Australia/Brisbane";

  environment.systemPackages = with pkgs; [
    wget
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
  ];

  security.sudo.extraConfig = "Defaults env_reset,timestamp_timeout=-1";
}
