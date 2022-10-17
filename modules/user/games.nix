{pkgs, lib, config, ...}:
with pkgs;
with lib;
with builtins;
let
    cfg = config.sys;
in {
    sys.user.userRoles.games = [
        (user: mergeUser user {
            software = with pkgs; [
                steam
                steam-run
                steam-tui
                steamcmd
                protontricks
                protonup
                lutris
                retroarchFull

            ];
        })
    ];
}
