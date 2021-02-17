{ fetchzip, stdenv }:
stdenv.mkDerivation {
  pname = "proton-6.1-GE-1";
  version = "6.1.1";

  src = fetchzip {
    url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/6.1-GE-1/Proton-6.1-GE-1.tar.gz";
    sha256 = "S1buBkL2xdk+zUkJcMcb84q8wwVkSxtQVtrbT/KmgTk=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir $out/proton -p
    cp $src $out/proton -RT
  '';

}
