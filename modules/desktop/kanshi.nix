{pkgs, lib, config, ...}: 
with builtins;
with pkgs;
with lib;
let
  cfg = config.sys.desktop.kanshi;
  wayland = (elem "wayland" config.sys.hardware.graphics.desktopProtocols);
  desktopMode = wayland;
  mkConfigLine = name: value: "\toutput ${name} ${value}\n";
  mkProfile = set: let
    topLine = ["profile {\n"];
    lines = map(name: mkConfigLine name (getAttr name set)) (attrNames set);
    bottomLine = ["}\n"];
    allLines = topLine ++ lines ++ bottomLine;
  in foldl' (l: r: l + r) "" allLines;

  genFile = let
    profiles = map(p: mkProfile p) cfg.profiles;
  in foldl' (l: r: l + r) "" profiles;
in {
  options.sys.desktop.kanshi = {
    profiles = mkOption {
      description = "Enable kanshi to do monitor auto selection";
      type = types.listOf types.attrs;
      default = [];
    };

  };

  config = mkIf desktopMode {
    sys.users.allUsers.files = {
      kanshiConfig = {
        path = ".config/kanshi/config";
        text = genFile;
      };
    };
  };
}
