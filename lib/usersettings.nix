{pkgs, lib, config, ...}:
{
  mkUser = { username }:
  let
    modList = import ../modules/user-settings;

    loadMod = name: {
      "${username}" = import (../modules/user-settings + "/${name}"){
        inherit username config lib pkgs;
        homedir = "/home/${username}";
      };
    };

    mods = (map (m: loadMod m) modList);
  in {
    imports = mods;
  };
}
