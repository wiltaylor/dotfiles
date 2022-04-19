{pkgs, config, lib, ...}:
with lib;
with builtins;
let
  desktopMode = (length config.sys.graphics.desktopProtocols) > 0;
in {
  ## This is a list of core software I want to have on all of my machines.

  environment.systemPackages = with pkgs; [
    accountsservice
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
    strace
    ltrace
    git
    git-crypt
    gh
    tmux
    zsh
    unrar
    acpi
    hwdata
    pciutils
    pwgen
    usbutils
    bintools
    btrfs-progs
    smartmontools
    iotop
    fuse-overlayfs
    unionfs-fuse
    squashfsTools
    squashfuse
    parted
    xar
    ripgrep
    nvme-cli
    pstree
    dmg2img
    lf
    nix-index
    darling-dmg
    nmap
    ntfsprogs
    samba

    #neovimWT
    lm_sensors
    shellcheck
    dev
    socat

    (mkIf desktopMode freerdp)

    wksCli
    rnix-lsp
    bubblewrap
    ventoy-bin
    rtw88-firmware
    unixtools.xxd
    ventoy-bin

    python3 # I want to remove this eventually and get most dev dependancies out of my base environment
  ];

  environment.variables = {
    WTDEV = "/home/wil/repo/github.com/wiltaylor/dev-profile";

  };

  # You need to add bash and zsh as login shells or dmlight won't recognise your user.
  environment.shells = [ pkgs.zsh pkgs.bash ];
}
