{ pkgs, ...}:
{
  mkFlakeApp = { app, name }:
    pkgs.writeScriptBin name ''
      #!${pkgs.bash}/bin/bash
      nix run ${app} $@
    '';
}
