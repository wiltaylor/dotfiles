{pkgs, lib, config, ...}:
{
  environment.systemPackages = with pkgs; [
    ansible
    terraform
    consul
    nomad
    vault
  ];
}
