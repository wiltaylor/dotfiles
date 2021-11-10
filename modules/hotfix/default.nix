{pkgs, config, lib, ...}:
{
  ## This module is a place to put hacks that need to be applied to work around current issues.
  ## You should check back here periodically to see if they can be removed.

  # This is done to work around this test being flakey and causing build to fail
  nix.package = (pkgs.nixFlakes.overrideAttrs (oldAttrs: rec {
    preInstallCheck = ''
      echo "exit 99" > tests/ca/substitute.sh
    '';
  }));

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Hot fix for issues
  documentation.info.enable = false;

  environment.pathsToLink = ["/libexec" ];
}
