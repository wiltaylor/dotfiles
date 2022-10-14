{pkgs, config, lib, ...}:
with lib;
with builtins;
let
in {
  imports = [ ./scripts.nix ];
}
