{pkgs, ... }:
{
  config = {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = import ../pkgs;
  };

  imports = [
    ./g810led
  ];
}
