{ pkgs, system, lib, ...}:
{
  host = import ./host.nix { inherit system pkgs lib;  };
}    
