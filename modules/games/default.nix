{pkgs, config, lib, ...}:
with lib;
with builtins;
let
  cfg = config.sys.games;
  mkProtonDerivation = {name, version, url, hash}: pkgs.stdenv.mkDerivation {
    pname = name;
    version = version;

    src = pkgs.fetchzip {
      url = url;
      sha256 = hash;
    };

    dontBuild = true;
    installPhase = ''
      mkdir $out/proton -p
      cp $src $out/proton -RT
    '';
  };

  kernelPackage = config.sys.kernelPackage;

  mkProtonShareFile = {name, version, url, hash}: {
    path = ".steam/root/compatibilitytools.d/${name}";
    source = "${mkProtonDerivation {inherit name version url hash;}}/proton";
  };

  mkAllProtonGE = all: listToAttrs (map (name: { name = name; value = mkProtonShareFile {
    name = name; 
    version = all."${name}".version; 
    url = all."${name}".url;
    hash = all."${name}".hash;
  }; }) (attrNames all));

in {
  imports = [ ./proton.nix ];

  options.sys.games = {
    enable = mkEnableOption "Enables games";

    protonGE = mkOption {
      type = types.attrs;
      default = {};
      description = "Proton GE builds to make available";
    };
  };

  config = mkIf cfg.enable {
    sys.users.allUsers.files = mkAllProtonGE cfg.protonGE;

    #boot.extraModulePackages = [
    #  kernelPackage.xpadneo
    #];

    environment.systemPackages = with pkgs; [
      steam
      steam-run
      xonotic
      vkquake
      minecraft
      quakespasm
      superTuxKart
      lutris
    ];
  };
}
