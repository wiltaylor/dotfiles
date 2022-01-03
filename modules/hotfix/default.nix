{pkgs, config, lib, ...}:
{
  ## This module is a place to put hacks that need to be applied to work around current issues.
  ## You should check back here periodically to see if they can be removed.

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  environment.pathsToLink = ["/libexec" ];
}
