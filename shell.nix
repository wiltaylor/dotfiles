{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  name = "nixosbuildshell";
  nativeBuildInputs = with pkgs; [
    git
    git-crypt
    unstable.nixUnstable
  ];

  shellHook = ''
      PATH=${pkgs.writeShellScriptBin "nix" ''
        ${pkgs.nixFlakes}/bin/nix --option experimental-features "nix-command flakes" "$@"
      ''}/bin:$PATH
    '';
  }
