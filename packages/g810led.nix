{ fetchFromGitHub, pkgs, stdenv, lib }:

with lib;
stdenv.mkDerivation {
  pname = "g810led";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "MatMoul";
    repo = "g810-led";
    rev = "5ee810a520f809e65048de8a8ce24bac0ce34490";
    sha256 = "1ymkp7i7nc1ig2r19wz0pcxfnpawkjkgq7vrz6801xz428cqwmhl";
  };

  buildInputs = [ pkgs.hidapi ];

  dontBuild = true;

  installPhase = ''
   make bin
   mkdir $out -p
   mkdir $out/etc/g810-led/samples -p
   mkdir $out/etc/udev/rules.d -p
   mkdir $out/usr/lib/systemd/system -p
   cp -R bin $out
   ln -s $out/bin/g810-ld $out/bin/g213-led
   ln -s $out/bin/g810-ld $out/bin/g410-led
   ln -s $out/bin/g810-ld $out/bin/g413-led
   ln -s $out/bin/g810-ld $out/bin/g512-led
   ln -s $out/bin/g810-ld $out/bin/g513-led
   ln -s $out/bin/g810-ld $out/bin/g610-led
   ln -s $out/bin/g810-ld $out/bin/g815-led
   ln -s $out/bin/g810-ld $out/bin/gpro-led
   cp sample_profiles/* $out/etc/g810-led/samples
   cp udev/g810-led.rules $out/etc/udev/rules.d
   cp systemd/g810-led-reboot.service $out/usr/lib/systemd/system

  '';
}
