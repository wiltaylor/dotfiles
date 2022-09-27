{pkgs, config, lib,  ...}:
with lib;
with builtins;

let
  mkScriptTool = scriptOpts: 
  let
    mkOption = name: ''
    "${name}")
        ${name}handler "$@"
    ;;
    '';
        
    mkAction = name: body: ''
    ${name}handler() {
    ${body}
    }
    '';

    mkUsage = name: msg: ''
    echo "${name} - ${msg}"
    '';

    mkLongUsage = name: msg: ''
    ${name}usage() {
    echo "$progname ${name}"
    echo ""
    echo "${msg}"
    }
    '';

    mkLongHelpSelect = name: ''
    "${name}")
        ${name}usage
    ;;
    '';

    actions = concatStrings (map (opt: (mkAction opt.name opt.action)) scriptOpts);
    selects = concatStrings (map (opt: (mkOption opt.name)) scriptOpts);
    usage = concatStrings (map (opt: (mkUsage opt.name opt.shortHelp)) scriptOpts);
    longusage = concatStrings (map (opt: (mkLongUsage opt.name opt.longHelp)) scriptOpts);
    usageselect = concatStrings(map (opt: (mkLongHelpSelect opt.name)) scriptOpts);
  in ''
    #!${runtimeShell}
    
    ## Action Functions
    ${actions}

    ## Usage Functions
    ${longusage}

    helpcommand() {
      case $1 in 
      ${usageselect}
      *)
        echo "Unknown Command"
      ;;
      esac
       
    }

    cmd=$1
    progname="$(basename $0)"
    shift 1
    case $cmd in
    ${selects}
    "help")
        helpcommand $1
    ;;
    *)
    echo "Usage:"
    echo "$progname <command> [options]"
    echo "help <command> - Get more help on specific sub command"
    ${usage}

    ;;
    esac
  '';

  runtimeShell = pkgs.runtimeShell;
  cfg = config.sys.scripts;

  systTool = pkgs.writeScriptBin "syst" (mkScriptTool [
    {
        name = "clean";
        action = ''
            nix-store --gc
            nix-store --optimise
        '';
        shortHelp = "Runs garbage collection against nixstore";
        longHelp = "Runs garbage collection against nixstore.";
    }

    {
        name = "update";
        action = ''
            cd ~/.dotfiles
            nix flake update
        '';
        shortHelp = "Updates the dotfile flake.";
        longHelp = "Updates all the inputs of the dotfiles flake to the latest version.";
    }

    {
        name = "update-index";
        action ='' 
            nix-index
            manix notindocsatall --update-cache 2>&1  > /dev/null
        '';
        shortHelp = "Updagtes the nix index file.";
        longHelp = "Updates the nix index file. This is used to find commands in nixpkgs.";
    }
    
    {
        name = "find";
        action = ''
            cd ~/.dotfiles
            nix search .# $1
        '';
        shortHelp = "Search for packages.";
        longHelp = "This searches both nixpkgs and local selected overlays.";
    }
    {
        name = "find-doc";
        action = '' 
            manix $1
        '';
        shortHelp = "Search for module options in nixpkgs.";
        longHelp = "Search for module options in nixpkgs.";
    }

    {
        name = "find-cmd";
        action = ''
            nix-locate --whole-name --type x --type s --no-group --type x --type s --top-level --at-root "/bin/$1"
        '';
        shortHelp = "Searches for a package containing target executable.";
        longHelp = "Searches for a package with the target executable.";
    }
    
    {
        name = "apply";
        action = ''
          cd ~/.dotfiles
          if [ -z "$2" ]; then
            sudo ls > /dev/null
            sudo nixos-rebuild switch --flake '.#'
          elif [ $2 = "--boot" ]; then
            sudo ls > /dev/null
            sudo nixos-rebuild boot --flake '.#'
          elif [ $2 = "--test" ]; then
            sudo ls > /dev/null
            nixos-rebuild build --flake '.#'
            sudo ./result/bin/switch-to-configuration test
          elif [ $2 = "--check" ]; then
            nixos-rebuild dry-activate --flake '.#'
          else
            echo "Unknown option $2"
          fi
        '';
        shortHelp = "Apply dot file configuration to system.";
        longHelp = ''
            Apply dotfile configuraiton to the system.

            This also has the following switchs:

            --boot - Applies the with boot flag. Will only apply on reboot.
            --test - Builds the config and runs the test option.
            --check - Does a dry run of the build.

            Leaving no flags will just install the config to your system as expected.
        '';
    }

    {
        name = "vm";
        action = ''
            cd ~/.dotfiles
            nixos-rebuild --flake ".#$1" build-vm
            "./result/bin/run-$1-vm"
        '';
        shortHelp = "Installs the configuration into a VM and boots it for testing.";
        longHelp = "Installs the configuration into a VM and boots it for testing.";
    }

    {
        name = "resetyk";
        action = ''
          gpg-connect-agent "scd serialno" "learn --force" /bye
          ssh-add
          gpgconf --reload gpg-agent
        '';
        shortHelp = "Reset yubikey gpg settings.";
        longHelp = "Reset yubikey gpg settings. This allows you to swap the yubikey used on the system and resolves any issues that requires a reset.";
    }

    {
        name = "exec";
        action = ''
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
     
        '';
        shortHelp = "Executes a command from nixpkgs.";
        longHelp = "Executes a command from nixpkgs. Type the command and it will search for it.";
    }
  ]);
in {
  options.sys.scripts = {
    systemScripts = mkOption {
      default = true;
      description = "Enable system management scripts like syst";
      type = types.bool;
    };
  };

  config = {

    environment.systemPackages = if (cfg.systemScripts) then [ systTool ] else []; 
  };
}
