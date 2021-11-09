{ system, pkgs, home-manager, lib, user, ...}:
with builtins;
{

  mkISO = { name, initrdMods, kernelMods, kernelParams, kernelPackage, roles }:
    let
      roles_mods = (map (r: mkRole r) roles );

      mkRole = name: import (../roles/iso + "/${name}");

    in lib.nixosSystem {
      inherit system;

      specialArgs = {};

      modules = [
        {
          imports = [ ../modules ] ++ roles_mods;

          networking.hostName = "${name}";
          networking.useDHCP = true;

          boot.initrd.availableKernelModules = initrdMods;
          boot.kernelModules = kernelMods;

          boot.kernelParams = kernelParams;
          boot.kernelPackages = kernelPackage;

          nixpkgs.pkgs = pkgs;

        }
      ];
    };

    mkHost = { 
      name, 
      cfg ? {},
      NICs, 
      initrdMods,
      kernelParams, 
      kernelMods,
      roles, 
      laptop, 
      wifi ? [],
      gpuTempSensor ? null,
      cpuTempSensor ? null}:
    let
      networkCfg = listToAttrs (map (n: {
        name = "${n}"; value = { useDHCP = true; };
      }) NICs);

      secretsResult = tryEval (import ../.secret/default.nix);
      secrets = if secretsResult.success then secretsResult.value else {};

      roles_mods = (map (r: mkRole r) roles );

      flaten = lst: foldl' (l: r: l // r) {} lst;

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

          boot.initrd.availableKernelModules = initrdMods;
          boot.kernelModules = kernelMods;
          boot.kernelParams = kernelParams;

          nixpkgs.pkgs = pkgs;

          system.stateVersion = "20.09";

        }

      ];
    };


}
