{ stdenv, buildGoPackage, fetchFromGitHub }:
buildGoPackage {
  pname = "masterplan";
  version = "0.6.0";

  goPackagePath = "github.com/SolarLune/masterplan";

  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "SolarLune";
    repo = "masterplan";
    rev = "a32835424e7b188f3161abd7a6c2caace30e6780";
    sha256 = "sha256-VB5+1M8d/Lfk3IKmx6f64s8r6+kGjyIxWYpIpv0JY/g=";
  };

}
