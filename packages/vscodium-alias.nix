# Dodgy derivation which creates a code link to codium
{ pkgs }:

(import <nixpkgs> {}).runCommand "vscodium-alias" {} ''
mkdir -p $out/bin
ln -s ${pkgs.vscodium}/bin/codium $out/bin/code
''
