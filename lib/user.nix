{ pkgs, home-manager, lib, system, overlays, ... }:
with builtins;
{

 mkHMUser = {roles, username}:
  home-manager.lib.homeManagerConfiguration {
    inherit system username pkgs;
    configuration = let
      mkRole = name: import (../roles/users + "/${name}");
      mod_roles = map (r: mkRole r) roles;
      trySettings = tryEval(fromJSON(readFile(/etc/hmsystemdata.json)));
      machineData = if trySettings.success then trySettings.value else {};

      machineModule = { pkgs, config, lib, ...}: {
        options.machineData = lib.mkOption {
          default = {};
          description = "Settings passed from nixos system configuration. If not present will be empty.";
        };

        config.machineData = machineData;
      };
    in {

      nixpkgs.overlays = overlays;
      nixpkgs.config.allowUnfree = true;
       
      systemd.user.startServices = true;
      home.stateVersion = "20.09";
      home.username = username;
      home.homeDirectory = "/home/${username}";

      imports = mod_roles ++ [machineModule];

    };
    homeDirectory = "/home/${username}";
  };
}
