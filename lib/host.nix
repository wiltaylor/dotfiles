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
      NICs, 
      initrdMods,
      kernelMods, 
      kernelParams, 
      kernelPackage, 
      roles, 
      cpuCores, 
      laptop, 
      users, 
      wifi ? [],
      gpuTempSensor ? null,
      cpuTempSensor ? null}:
    let
      networkCfg = listToAttrs (map (n: {
        name = "${n}"; value = { useDHCP = true; };
      }) NICs);

      userCfg = {
        inherit name NICs roles cpuCores laptop gpuTempSensor cpuTempSensor;
      };

      sysdata = [{
        options.laptop = lib.mkEnableOption "test";
      }];

      roles_mods = (map (r: mkRole r) roles );
      sys_users = (map (u: user.mkSystemUser u) users);

      flaten = lst: foldl' (l: r: l // r) {} lst;

      mkRole = name: import (../roles + "/${name}");

    in lib.nixosSystem {
      inherit system;

      modules = [
        {
          imports = [ ../modules ] ++ roles_mods ++ sys_users;

          environment.etc = {
            "hmsystemdata.json".text = builtins.toJSON userCfg;
          };

          networking.hostName = "${name}";
          networking.interfaces = networkCfg;
          networking.wireless.interfaces = wifi;

          networking.networkmanager.enable = true;
          networking.useDHCP = false; # Disable any new interface added that is not in config.

          boot.initrd.availableKernelModules = initrdMods;
          boot.kernelModules = kernelMods;
          boot.kernelParams = kernelParams;
          #boot.kernelPackages = kernelPackage;
          wt.machine.kernelPackage = kernelPackage;

          nixpkgs.pkgs = pkgs;
          nix.maxJobs = lib.mkDefault cpuCores;

          system.stateVersion = "20.09";

        }

      ];
    };


}
