{config, pkgs, lib, ...}:
let
  sysTool = pkgs.writeScriptBin "sys" ''
    if [ -n "$INNIXSHELLHOME" ]; then
      echo "You are in a nix shell that redirected home!"
      echo "SYS will not work from here properly."
      exit 1
    fi 

    case $1 in
    "clean")
      echo "Running Garbage collection"
      nix-store --gc
      echo "Deduplication running...this may take awhile"
      nix-store --optimise
    ;;

    "update")
      echo "Updating dotfiles flake..."
      pushd ~/.dotfiles
      nix flake update --recreate-lock-file
      popd
    ;;

    "find")
      if [ $2 = "--overlay" ]; then
        pushd ~/.dotfiles
        nix search .# $3
        popd
      else 
        nix search nixpkgs $2
      fi
    ;;

    "find-doc")
      ${pkgs.manix}/bin/manix $2 
    ;;

    "apply")
      pushd ~/.dotfiles
      if [ -z "$2" ]; then
        sudo nixos-rebuild switch --flake '.#'

      elif [ $2 = "--boot" ]; then
        sudo nixos-rebuild boot --flake '.#' 
      elif [ $2 = "--test" ]; then
        sudo nixos-rebuild test --flake '.#'
      elif [ $2 = "--check" ]; then
        nixos-rebuild dry-activate --flake '.#'
      else
        echo "Unknown option $2"
      fi

      popd
  
    ;;
    "iso")
      echo "Building iso file $2"
      pushd ~/.dotfiles
      nix build ".#installMedia.$2.config.system.build.isoImage"

      if [ -z "$3" ]; then
        echo "ISO Image is located at ~/.dotfiles/result/iso/nixos.iso"
      elif [ $3 = "--burn" ]; then
        if [ -z "$4" ]; then
          echo "Expected a path to a usb drive following --burn."
        else 
          sudo dd if=./result/iso/nixos.iso of=$4 status=progress bs=1M
        fi
      else
        echo "Unexpected option $3. Expected --burn"
      fi 
      popd

    ;;
    *)
      echo "Usage:"
      echo "sys command"
      echo ""
      echo "Commands:"
      echo "clean - GC and hard link nix store"
      echo "update - Updates dotfiles flake."
      echo "find [--overlay] - Find a nix package (overlay for custom packages)."
      echo "find-doc - Finds documentation on a config item"
      echo "apply - Applies current configuration in dotfiles."
      echo "iso image [--burn path] - Builds nixos install iso and optionally copies to usb."
    ;;
    esac
  '';

in {
  system.stateVersion = "20.09";

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
    sysTool 
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
    parted
    xar
    darling-dmg
    ( pkgs.runCommand "neovim-alias" {} ''
	mkdir -p $out/bin
	ln ${pkgs.neovim}/bin/nvim $out/bin/vim -sf
	ln ${pkgs.neovim}/bin/nvim $out/bin/vi -sf
    '')
  ];

  security.sudo.extraConfig = "Defaults env_reset,timestamp_timeout=-1";
}
