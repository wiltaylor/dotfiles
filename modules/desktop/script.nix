{pkgs, config, lib, ...}:
with pkgs;
with lib;
let 
    cfg = config.sys;
in {
  config = {
    sys.script.desktop2 = [
    {
        name = "wallpaper";
        action = ''
        '';
        shortHelp = "Randomly selects a new wallpaper.";
        longHelp = "Randomly selects a new wallpaper.";
    }
    {
        name = "winman";
        action = ''
        '';
        shortHelp = "Prints the current window manager name.";
        longHelp = "Prints the current window manager name";
    }
    {
        name = "screenshot";
        action = ''
        '';
        shortHelp = "Takes a screenshot.";
        longHelp = "Takes a screenshot.";
    }
    {
        name = "lock";
        action = ''
        '';
        shortHelp = "Locks the computer.";
        longHelp = "Locks the computer.";
    }
    {
        name = "volup";
        action = ''
        '';
        shortHelp = "Increments the volume up.";
        longHelp = "Increments the volume up.";
    }
    {
        name = "voldown";
        action = ''
        '';
        shortHelp = "Decrements the volume down.";
        longHelp = "Decrements the volume down.";
    }
    {
        name = "volmute";
        action = ''
        '';
        shortHelp = "Mutes the volume.";
        longHelp = "Mutes the volume.";
    }
    {
        name = "vol";
        action = ''
        '';
        shortHelp = "Prints the current volume.";
        longHelp = "Prints the current volume.";
    }
    {
        name = "cputemp";
        action = ''
        '';
        shortHelp = "Prints the cpu temp.";
        longHelp = "Prints the cpu temp.";
    }
    {
        name = "gputemp";
        action = ''
        '';
        shortHelp = "Prints the gpu temp.";
        longHelp = "Prints the gpu temp.";
    }
  ];
  };
}
