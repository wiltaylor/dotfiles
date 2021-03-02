{ pkgs, home-manager, system, lib, ...}:
{
  user = import ./user.nix { inherit pkgs home-manager; };
  host = import ./host.nix { inherit system pkgs home-manager lib; };
  shell = import ./shell.nix { inherit pkgs; };
  userSettings = import ./usersettings.nix { inherit pkgs; };
}
