{config, pkgs, lib, modulesPath, ...}:
{
  system.stateVersion = "20.09";

  nix = {
    extraOptions = "experimental-features = nix-command flakes";
    gc = {
      automatic = true;
      options = "--delete-older-than 5d";
    };
    package = pkgs.nixFlakes;

  };

  # Make this config a iso config
  imports = [ "${modulesPath}/installer/cd-dvd/iso-image.nix" ];

  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;

  i18n.defaultLocale = "en_AU.UTF-8";
  time.timeZone = "Australia/Brisbane";
  services.earlyoom.enable = true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
  hardware.enableRedistributableFirmware = lib.mkDefault true;


  environment.pathsToLink = ["/libexec" ]; 

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
    my.dotfiles-manpages
    acpi
    nix-index
    unstable.btrfs-progs
    smartmontools
    neovim
    zfs
    iotop
    nvme-cli
    lm_sensors
    ( pkgs.runCommand "neovim-alias" {} ''
	mkdir -p $out/bin
	ln ${pkgs.neovim}/bin/nvim $out/bin/vim -sf
	ln ${pkgs.neovim}/bin/nvim $out/bin/vi -sf
    '')
  ];

  security.sudo.extraConfig = "Defaults env_reset,timestamp_timeout=-1";
}
