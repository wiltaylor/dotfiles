{ pkgs, system, lib, ...}:
{
  inherit (import ./host.nix { inherit system pkgs lib;  });
}    
