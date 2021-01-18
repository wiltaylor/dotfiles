{ fetchzip, stdenv }:
stdenv.mkDerivation {
  pname = "proton-5.21-GE-1";
  version = "5.21.1";

  src = fetchzip {
    url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/5.21-GE-1/Proton-5.21-GE-1.tar.gz";
    sha256 = "CmJWgBbkWV0DzukQdk+HQW8pmWWguIzX1o4qC+j4G38=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir $out/proton -p
    cp $src $out/proton -RT
  '';

}

