{pkgs, config, lib, ...}:
{
    imports = [
        ./software.nix
        ./disk.nix
        ./kernel.nix
        ./nix.nix
        ./syst.nix
        ./regional.nix
        ./security.nix
        ./shell.nix
        ./virtualisation.nix
    ];
}
