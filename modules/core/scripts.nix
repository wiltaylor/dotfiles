{pkgs, config, lib,  ...}:
with lib;
with builtins;

let
  runtimeShell = pkgs.runtimeShell;
  cfg = config.sys.scripts;

  sysTool = pkgs.writeScriptBin "sys" ''
    #!${runtimeShell}

    applyMachine() {
      echo "--------------------------------------------------------------------------------"
      echo " Applying Machine Settings"
      echo "--------------------------------------------------------------------------------"

      # There is a security fix in git that prevents you from building a repo that is not owned by root when you are root.
      # https://github.com/NixOS/nixpkgs/issues/169193
      # Because of this I am calling nix-rebuild build and then manually calling it's activation script.
 
      pushd ~/.dotfiles
      if [ -z "$2" ]; then
        # Prompt for password before doing build so it doesn't sit waiting and time out.
        sudo ls > /dev/null
        nixos-rebuild build --flake '.#'
        sudo ./result/bin/switch-to-configuration switch

      elif [ $2 = "--boot" ]; then

        # Prompt for password before doing build so it doesn't sit waiting and time out.
        sudo ls > /dev/null

        nixos-rebuild build --flake '.#'
        sudo ./result/bin/switch-to-configuration boot
      elif [ $2 = "--test" ]; then

        # Prompt for password before doing build so it doesn't sit waiting and time out.
        sudo ls > /dev/null

        nixos-rebuild build --flake '.#'
        sudo ./result/bin/switch-to-configuration test
      elif [ $2 = "--check" ]; then

        nixos-rebuild dry-activate --flake '.#'
      else
        echo "Unknown option $2"
      fi

      popd
    }

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
      git pull
      nix flake update
      popd
    ;;
    "update-index")
      echo "Updating index. This will take a while"
      nix-index
    ;;
    "save")
      echo "Saving changes"
      pushd ~/.dotfiles
      git diff
      git add .
      git commit
      git pull --rebase
      git push
    ;;
    "find")
      pushd ~/.dotfiles
      nix search .# $2
      popd
    ;;

    "find-doc")
      ${pkgs.manix}/bin/manix $2
    ;;

    "find-cmd")
      nix-locate --whole-name --type x --type s --no-group --type x --type s --top-level --at-root "/bin/$2"
    ;;

    "apply")
      applyMachine
    ;;

    "exec")
      shift 1
      cmd=$1
      pkgs=$(nix-locate --minimal --no-group --type x --type s --top-level --whole-name --at-root "/bin/$cmd")
      count=$(echo -n "$pkgs" | grep -c "^")

      case $count in
        0)
          >&2 echo "$1: not found!"
          exit 2
        ;;
        1)

          nix-build --no-out-link -A $pkgs "<nixpkgs>"
          if [ "$?" -eq 0 ]; then
            nix-shell -p $pkgs --run "$(echo $@)"
            exit $?
          fi
        ;;
        *)
          PS3="Please select package to run command from:"
          select p in $pkgs
          do
            nix-build --no-out-link -A $p "<nixpkgs>"
            if [ "$?" -eq 0 ]; then
              nix-shell -p $pkgs --run "$(echo $@)"
              exit $?
            fi

            >&2 echo "Unable to run command"
            exit $?
          done
        ;;
      esac
    ;;
    "vm")
      pushd ~/.dotfiles
      shift 1
      nixos-rebuild --flake ".#$1" build-vm
      "./result/bin/run-$1-vm"
      popd
    ;;
    "resetyk")
      gpg-connect-agent "scd serialno" "learn --force" /bye
      ssh-add
      gpgconf --reload gpg-agent
    ;;
    *)
      echo "Usage:"
      echo "sys command"
      echo ""
      echo "Commands:"
      echo "clean - GC and hard link nix store"
      echo "update - Updates dotfiles flake."
      echo "update-index - Updates the index of commands in nixpkgs. Used for exec"
      echo "find [--overlay] - Find a nix package (overlay for custom packages)."
      echo "find-doc - Finds documentation on a config item"
      echo "find-cmd - Finds the package a command is in"
      echo "apply - Applies current system configuration in dotfiles."
      echo "exec - executes a command"
      echo "vm {config} - Starts a vm to test the target config"
      echo "resetyk - Reset yubikey allowing you to put a different key in"
    ;;
    esac
  '';
in {
  options.sys.scripts = {
    systemScripts = mkOption {
      default = true;
      description = "Enable system management scripts like sys";
      type = types.bool;
    };
  };

  config = {

    environment.systemPackages = if (cfg.systemScripts) then [ sysTool ] else []; 
  };
}
