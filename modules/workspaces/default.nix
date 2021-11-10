{ pkgs, lib, config, ... }:
with builtins;
with lib;
let
  runtimeShell = pkgs.runtimeShell;
  wksScript = pkgs.writeScriptBin "wks" ''
    #!${runtimeShell}

    failIfInWorkspace() {
      if [[ ! -z "$NIX_WORKSPACE" ]]; then
        echo "You can't use this command while in a workspace. Please exit and try again."
        exit 5000
      fi
    }

    installWorkspace() {
      failIfInWorkspace 

      local flake=$1
      local workspaceName="$(nix shell $flake -c workspaceInfo)"

      mkdir -p "$HOME/.local/share/nixworkspace/$workspaceName/.profile"
      mkdir -p "$HOME/.local/share/nixworkspace/$workspaceName/home"

      touch "$HOME/.local/share/nixworkspace/$workspaceName/home/.zshrc"
      touch "$HOME/.local/share/nixworkspace/$workspaceName/home/.bashrc"

      echo "$flake" > "$HOME/.local/share/nixworkspace/$workspaceName/.flake"

      nix build $flake --profile "$HOME/.local/share/nixworkspace/$workspaceName/.profile"

      echo "Installed $workspaceName from $flake"
    }

    uninstallWorkspace() {
      failIfInWorkspace

      local workspaceName=$1

      rm -fr "$HOME/.local/share/nixworkspace/$workspaceName"
    }

    updateWorkspace()  {
      failIfInWorkspace

      local workspaceName=$1
      local flake=$(cat "$HOME/.local/share/nixworkspace/$workspaceName/.flake")

      nix build $flake --profile "$HOME/.local/share/nixworkspace/$workspaceName/.profile"

      echo "Updated $workspaceName from $flake"
    }

    enterWorkspace() {
      failIfInWorkspace

      local workspaceName=$1

      "$HOME/.local/share/nixworkspace/$workspaceName/.profile/bin/activateWorkspace"

      echo "Leaving workspace..."
      exit
    }

    runInWorkspace() {
      failIfInWorkspace

      local workspaceName=$1
      shift 

      "$HOME/.local/share/nixworkspace/$workspaceName/.profile/bin/activateWorkspace" $@
      exit
    }

    list() {
      failIfInWorkspace
      echo "Installed Workspaces:"
      find $HOME/.local/share/nixworkspace -maxdepth 1 -printf "%f\n"| sed 1,1d
      echo ""
    }

    versions() {
      failIfInWorkspace
      local workspaceName=$1

      echo "Workspace versions:"
      nix profile history --profile "$HOME/.local/share/nixworkspace/$workspaceName/.profile" 
    }

    rollback() {
      failIfInWorkspace
      local workspaceName=$1
      local version=$2

      nix profile rollback --to $version --profile "$HOME/.local/share/nixworkspace/$workspaceName/.profile" 
    }

    clean() {
      failIfInWorkspace
      local workspaceName=$1

      nix profile wipe-history --profile "$HOME/.local/share/nixworkspace/$workspaceName/.profile"
    }

    usage() {
      echo "Usage:"
      echo "wks command"
      echo ""
      echo "Commands:"
      echo "install <flake and package> - Installs a workspace"
      echo "uninstall <workspacename> - Removes a workspace"
      echo "update <workspacename> - updates a installed workspace"
      echo "ls - Lists all workspaces installed on the system"
      echo "enter <workspace> - Enters a workspace"
      echo "run <workspace> <command> - Executes a command in the workspace"
      echo "rollback <workspace> <version> - Rolls back workspace to a previous version"
      echo "versions <workspace> - Shows all of the versions of a workspace on the system"
      echo "clean <workspace> - Removes all other versions of workspace to clean it up"
      echo ""
      echo "Examples:"
      echo "Install a workspace from a flake"
      echo "$>wks install github:wiltaylor/browsers#workspace"
      echo ""
      echo "Remove a workspace"
      echo "$>wks uninstall browsers"
      echo ""
      echo "Update a workspace"
      echo "$>wks update browsers"
      echo ""
      echo "Enter an interactive shell in workspace"
      echo "$>wks enter"
      echo ""
      echo "Launch a command in a workspace"
      echo "$>wks run browsers firefox -?"
    }

    command=$1
    shift

    case $command in 
      "install")
        installWorkspace $@
      ;;
      "uninstall")
        uninstallWorkspace $@
      ;;
      "update")
        updateWorkspace $@
      ;;
      "ls")
        list
      ;;
      "enter")
        enterWorkspace $@
      ;;
      "run")
        runInWorkspace $@
      ;;
      "rollback")
        rollback $@
      ;;
      "versions")
        versions $@
      ;;
      "clean")
        clean $@
      ;;
      *)
        usage
      ;;
    esac
  '';
in {

  options = {};
  config = {
    environment.systemPackages = [
      wksScript
    ];
  };
}
