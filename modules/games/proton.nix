{pkgs, lib, config, ...}:
{
  config = {
    sys.games.protonGE = {
      "Proton_6.20-GE-1" = {
        version = "6.20.1";
        url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/6.20-GE-1/Proton-6.20-GE-1.tar.gz";
        hash = "sha256-vLQ22FfID+c+f17rwPyQZ+9PnsMmk5TORqyyiCrNPc4=";
      };

    };
  };
}
