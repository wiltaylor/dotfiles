{config, pkgs, lib, ...}:
let

  scripts = import ./scripts.nix { inherit pkgs; };

in {

  wil.xdg.config.files = {
    name = "test";
    path = "";
    text = ''
      test
    '';
  };

  nix = {
    extraOptions = "experimental-features = nix-command flakes";
    gc = {
      automatic = true;
      options = "--delete-older-than 5d";
    };
    package = pkgs.nixFlakes;

  };

  i18n.defaultLocale = "en_AU.UTF-8";
  time.timeZone = "Australia/Brisbane";
  services.earlyoom.enable = true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "perfomance";
  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
  hardware.enableRedistributableFirmware = lib.mkDefault true;


  environment.pathsToLink = ["/libexec" ];
  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [

    # Core utilities that need to be on every machine
    accountsservice
    wget
    my.pciutils
    my.hwdata
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
    acpi
    gh
    lf
    pwgen
    usbutils

    python3 # move out to things that need it
    nix-bundle # Move out
    scripts.sysTool
    scripts.devTool
    microcodeIntel # Move to intel package, get amd one too
    imagemagick # move out to shells
    pstree

    my.dotfiles-manpages # split out
    nix-index
    unstable.btrfs-progs
    smartmontools
    neovim
    iotop
    nvme-cli # Move to efi
    lm_sensors # Move to amd and intel
    fuse-overlayfs
    unionfs-fuse
    squashfsTools
    squashfuse
    parted
    xar
    darling-dmg
    linuxPackages_5_10.bpftrace # Add to diag pack

    kubectl # Should be moved to shell
    kubernetes-helm # Shell
    kind # above shell
    jp2a # Misc tools
    doctl # devops shell

    v4l-utils # Move out to video shell
    xawtv # video shell

    nmap # Security shell
    ( pkgs.runCommand "neovim-alias" {} ''
	mkdir -p $out/bin
	ln ${pkgs.neovim}/bin/nvim $out/bin/vim -sf
	ln ${pkgs.neovim}/bin/nvim $out/bin/vi -sf
    '')
  ];

  security.sudo.extraConfig = "Defaults env_reset,timestamp_timeout=-1";
}
