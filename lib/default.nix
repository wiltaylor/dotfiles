{ pkgs, home-manager, system, lib, overlays, ...}:
rec {
  user = import ./user.nix { inherit pkgs home-manager lib system overlays; };
  host = import ./host.nix { inherit system pkgs home-manager lib user; };
  shell = import ./shell.nix { inherit pkgs; };
  app = import ./app.nix { inherit pkgs; };
}    
