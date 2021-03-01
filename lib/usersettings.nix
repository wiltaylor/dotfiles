{pkgs, ...}:
{
  mkUser = { username, config }:
  let
    modList = import ../modules/user-settings;
    loadMod = name: import (../modules/user-settings + "/${name}");
    mods = (map (m: loadMod m) modList);
  in {

    imports = mods;

  };
}
