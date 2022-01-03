{ system, pkgs, lib, ...}:
with builtins;
{
    mkHost = { 
      name, 
      cfg ? {},
      NICs, 
      roles, 
      wifi ? []}:
    let
      networkCfg = listToAttrs (map (n: {
        name = "${n}"; value = { useDHCP = true; };
      }) NICs);

      secretsResult = tryEval (import ../.secret/default.nix);
      secrets = if secretsResult.success then secretsResult.value else {};

      roles_mods = (map (r: mkRole r) roles );

      mkRole = name: import (../roles + "/${name}");

    in lib.nixosSystem {
      inherit system;

      modules = [
        cfg
        {
          imports = [ ../modules ] ++ roles_mods; # ++ sys_users;

          sys.security.secrets = secrets;

          networking.hostName = "${name}";
          networking.interfaces = networkCfg;
          networking.wireless.interfaces = wifi;

          networking.networkmanager.enable = true;
          networking.useDHCP = false; # Disable any new interface added that is not in config.

          nixpkgs.pkgs = pkgs;

          system.stateVersion = "20.09";

        }

      ];
    };


}
