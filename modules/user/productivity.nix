{pkgs, lib, config, ...}:
with pkgs;
with lib;
with builtins;
let
    cfg = config.sys;
in {
    sys.user.userRoles.productivity = [
        (user: user // {
            software = with pkgs; [
                obsidian
                firefox
            ];
        })
    ];
}
