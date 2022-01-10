{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  name = "nixosbuildshell";
  nativeBuildInputs = with pkgs; [
    git
    git-crypt
    nixFlakes
  ];

  shellHook = ''
    alias foo="echo foo"

      echo "You can apply this flake to your system with nixos-rebuild switch --flake .#"

      PATH=${pkgs.writeShellScriptBin "nix" ''
        ${pkgs.nixFlakes}/bin/nix --experimental-features "nix-command flakes" "$@"
      ''}/bin:$PATH
    '';
  }
