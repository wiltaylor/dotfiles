{ fetchzip, stdenv }:
stdenv.mkDerivation {
  pname = "proton-6.1-GE-2";
  version = "6.1.2";

  src = fetchzip {
    url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/6.1-GE-2/Proton-6.1-GE-2.tar.gz";
    sha256 = "Hts25IC3NeOXoff7SnpwnAVm603RdF5noHBqppFxMT4=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir $out/proton -p
    cp $src $out/proton -RT
  '';

}
