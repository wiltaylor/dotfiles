{ pkgs, home-manager, ... }:
{
  mkUser = { name,groups, uid, shell, roles, ...}:
  let
    selectedShell = if shell == "zsh" then 
      pkgs.zsh
    else if shell == "fish" then
      pkgs.fish
    else
      pkgs.bash;

    mkRole = name: import (../roles/users + "/${name}");

    mod_roles = map (r: mkRole r) roles;

  in {
    users.users."${name}" = {
      name = "${name}";
      isNormalUser = true;
      extraGroups = groups;
      uid = uid;
      initialPassword = "P@ssw0rd01";
      shell = selectedShell;
    };

    home-manager.users."${name}" = {

      imports = mod_roles;
      
      nixpkgs = {
        config.allowUnfree = true;
        overlays = pkgs.overlays;
      };

      systemd.user.startServices = true;
      home.stateVersion = "20.09";
      home.username = name;
      home.homeDirectory = "/home/${name}";
    };
  };

}
