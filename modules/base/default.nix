{pkgs, config, lib, ...}:
{
    imports = [
        ./software.nix
        ./disk.nix
        ./kernel.nix
        ./nix.nix
        ./syst.nix
    ];
}
