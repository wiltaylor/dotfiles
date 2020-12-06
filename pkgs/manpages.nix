{ pkgs, config, lib, ...}:
pkgs.runCommand "dotfile-manpage" {} ''
  mkdir -p $out/share/man/man8
  cp ${../man/dotfiles} $out/share/man/man8/dotfiles.8
  gzip $out/share/man/man8/dotfiles.8
''
