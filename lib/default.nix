{ pkgs, home-manager, system, lib, ...}:
{
  user = import ./user.nix { inherit pkgs home-manager; };
  host = import ./host.nix { inherit system pkgs home-manager lib; };
}
