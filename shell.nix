{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  name = "nixosbuildshell";
  nativeBuildInputs = with pkgs; [
    git
    git-crypt
    nixFlakes
  ];

  shellHook = ''
      PATH=${pkgs.writeShellScriptBin "nix" ''
        ${pkgs.nixFlakes}/bin/nix --experimental-features "nix-command flakes" "$@"
      ''}/bin:$PATH
    '';
  }
