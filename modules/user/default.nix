{ pkgs, config, lib, ...}:
{
    imports = [
        ./core.nix
        ./productivity.nix
        ./development.nix
    ];
}
