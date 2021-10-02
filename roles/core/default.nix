{config, pkgs, lib, ...}:
let

  scripts = import ./scripts.nix { inherit pkgs; };

in {

  nix = {
    extraOptions = "experimental-features = nix-command flakes";
    gc = {
      automatic = true;
      options = "--delete-older-than 5d";
    };
    # This is done to work around this test being flakey and causing build to fail
    package = (pkgs.nixFlakes.overrideAttrs (oldAttrs: rec {
      preInstallCheck = ''
        echo "exit 99" > tests/ca/substitute.sh
      '';
    }));

  };

  environment.shells = [ pkgs.zsh pkgs.bash ];

  i18n.defaultLocale = "en_AU.UTF-8";
  time.timeZone = "Australia/Brisbane";
  services.earlyoom.enable = true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "perfomance";
  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  # Hot fix for issues
  documentation.info.enable = false;

  environment.pathsToLink = ["/libexec" ];
  virtualisation.docker.enable = true;

  boot.extraModulePackages = [
    pkgs.linuxPackages_latest.v4l2loopback
  ];

  boot.extraModprobeConfig = ''
    options v4l2loopback exclusive_caps=1 video_nr=9 card_label="obs"
  '';

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
    clang_11
    cookiecutter
    bintools

    python3 # move out to things that need it
    nix-bundle # Move out
    scripts.sysTool
    scripts.devTool
    scripts.prjTool
    microcodeIntel # Move to intel package, get amd one too
    imagemagick # move out to shells
    pstree

    my.dotfiles-manpages # split out
    nix-index
    btrfs-progs
    smartmontools
    #neovim
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
    #linuxPackages_latest.bpftrace # Add to diag pack
    linuxPackages_latest.v4l2loopback

    kubectl # Should be moved to shell
    kubernetes-helm # Shell
    kind # above shell
    jp2a # Misc tools
    doctl # devops shell

    v4l-utils # Move out to video shell
    libv4l
    xawtv # video shell

    nmap # Security shell

    neovimWT
    clinfo
    ripgrep
  ];

  security.sudo.extraConfig = "Defaults env_reset,timestamp_timeout=-1";
  security.sudo.execWheelOnly = true;
}
