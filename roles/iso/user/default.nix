{pkgs, config, lib, ...}:
{
  users.users.nixos = {
    name = "nixos";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    uid = 1000;
    initialPassword = "P@ssw0rd01";
    shell = pkgs.zsh;
  };
}
