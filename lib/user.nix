{ pkgs, home-manager, lib, config, ... }:
{

 mkSystemUser = {name, groups, uid, shell, ...}:
 {
    users.users."${name}" = {
      name = name;
      isNormalUser = true;
      extraGroups = groups;
      uid = uid;
      initialPassword = "P@ssw0rd01";
      shell = shell;
    };
  };

  mkHomeUser = {name, roles, sysdata, ...}:
  let
    mkRole = name: import (../roles/users + "/${name}");
    mod_roles = map (r: mkRole r) roles;
    sysmod = {...}: { inherit sysdata; };
  in {
    "${name}" =
    {
      imports = mod_roles ++ sysdata;

      systemd.user.startServices = true;
      home.stateVersion = "20.09";
      home.username = name;
      home.homeDirectory = "/home/${name}";
    };
  };
}
