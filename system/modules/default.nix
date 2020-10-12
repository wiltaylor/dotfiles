{pkgs, ... }:
{
  config = {
    nixpkgs.overlays = import ./pkgs;

  };

  imports = [
    ./g810-led.nix
    ./users.nix
    ./nixos.nix
  ];
}
