{pkgs, config, lib, ...}:
with lib;
with builtins;
let
  xorg = (elem "xorg" config.sys.graphics.desktopProtocols);
  desktopMode = xorg;
in {

  config = mkIf desktopMode {
    services.xserver.windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        i3blocks-gaps
        i3blocks-contrib
        sysstat
        i3lock
      ];
    };

    sys.users.allUsers.files = {
      i3blocksconfig = {
        path = ".config/i3/i3blocks.conf";
        text = ''
          [cpu_usage]
          command=echo " $(grep 'cpu ' /proc/stat | awk '{usage=int(($2+$4)*100/($2+$4+$5))} END {print usage "%"}')"
          interval=5

          [memory_usage]
          command=grep -E 'MemTotal|MemFree' /proc/meminfo | awk '/MemTotal/ {total=int($2/1024)} /MemFree/ {free=int($2/1024)} {used=total-free} END {print " " used "/" total "MB"}'
          interval=5

          [diskspace]
          command=echo " $(df / -H | grep '/' | awk '{print $3 "/" $2}')"
          interval=60

          # Update time every 5 seconds
          [time]
          command=date "+%Y-%m-%d %T"
          interval=5 
        '';
      };

      i3config = {
        path = ".config/i3/config";
        text = let 
          binDir = "/run/current-system/sw/bin";
        in ''
          ${config.sys.desktop.tilewm.extraConfig}
          ${config.sys.desktop.tilewm.extraConfigi3}
        '';
      };
    };
  };
}
