{ system, pkgs, home-manager, lib, ...}:
with builtins;
{
  mkHost = { name, NICs, initrdMods, kernelMods, roles, users, cpuCores }:
    let 
      networkCfg = listToAttrs (map (n: {
        name = "${n}"; value = { useDHCP = true; };
      }) NICs);

      roles_mods = (map (r: mkRole r) roles );
      user_mods = (map (u: mkUser u) users);

      mkRole = name: import (../roles + "/${name}.nix");

      mkUser = name: import (../users + "/${name}.nix");

    in lib.nixosSystem {
      inherit system;

      specialArgs = {};

      modules = [
        {
          imports = [ ../modules ] ++ roles_mods ++ user_mods;

          networking.hostName = "${name}";
          networking.interfaces = networkCfg;

          networking.networkmanager.enable = true;
          networking.useDHCP = false; # Disable any new interface added that is not in config.
        
          boot.initrd.availableKernelModules = initrdMods;
          boot.kernelModules = kernelMods;

          #imports = roles_mods; # ++ user_mods;

          nix.package = pkgs.unstable.nixUnstable;
          nixpkgs.pkgs = pkgs;
          nix.maxJobs = lib.mkDefault cpuCores;
        }

      home-manager.nixosModules.home-manager
      ];
    };


}
