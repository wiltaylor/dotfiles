{pkgs}:

(import <nixpkgs> {}).runCommand "vscodium-alias" {} ''
mkdir -p $out/bin
ln -s ${pkgs.vscodium}/bin/codium $out/bin/code
''
