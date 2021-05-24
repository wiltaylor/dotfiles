{ pkgs, ...}:
{
  mkFlakeApp = { app, name }:
    pkgs.writeScriptBin name ''
      nix run $(app) $@
    '';
}
