{pkgs, lib, config, ...}:
with pkgs;
stdenv.mkDerivation {
  pname = "i3blocks-contrib";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "vivien";
    repo = "i3blocks-contrib";
    rev = "154001e5713c26c70063446022919225b6f916f0";
    sha256 = "3G+UFXea2KYkIF1qwT6yeZmvr6f1/gdWLMaBTTERrGc=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir $out/share/i3blocks-contrib -p
    cp . -R $out/share/i3blocks-contrib
  '';
  
}
