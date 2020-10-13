# __          ___ _   _______          _
# \ \        / (_) | |__   __|        | |
#  \ \  /\  / / _| |    | | __ _ _   _| | ___  _ __
#   \ \/  \/ / | | |    | |/ _` | | | | |/ _ \| '__|
#    \  /\  /  | | |    | | (_| | |_| | | (_) | |
#     \/  \/   |_|_|    |_|\__,_|\__, |_|\___/|_|
#                                 __/ |
#                                |___/
# Web: https://wil.dev
# Github: https://github.com/wiltaylor
# Contact: web@wiltaylor.dev
# Feel free to use this configuration as you wish.

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
   ln -s $out/bin/g810-led $out/bin/g213-led
   ln -s $out/bin/g810-led $out/bin/g410-led
   ln -s $out/bin/g810-led $out/bin/g413-led
   ln -s $out/bin/g810-led $out/bin/g512-led
   ln -s $out/bin/g810-led $out/bin/g513-led
   ln -s $out/bin/g810-led $out/bin/g610-led
   ln -s $out/bin/g810-led $out/bin/g815-led
   ln -s $out/bin/g810-led $out/bin/gpro-led
   ln -s $out/bin/g810-led $out/bin/g910-led
   cp sample_profiles/* $out/etc/g810-led/samples
  '';
}
