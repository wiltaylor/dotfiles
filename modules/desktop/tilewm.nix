{pkgs, lib, config, ...}:
with pkgs;
with lib;
with builtins;
let

  wayland = (elem "wayland" config.sys.graphics.desktopProtocols);
  xorg = (elem "xorg" config.sys.graphics.desktopProtocols);

  desktopMode = if (wayland == null && xorg == null) then false else true;
  startupProgramType = with types; submodule {
    options = {
      always = mkOption {
        description = "Should program always start when config is reapplied. If false will only run on startup";
        default = false;
        type = types.bool;
      };
      command = mkOption {
        description = "Command to run";
        default = "";
        type = types.str;
      };
      startupId = mkOption {
        description = "Should --no-startup-id be passed to exec for this item";
        default = true;
        type = types.bool;
      };
    };
  };

  keybindingType = with types; submodule {
    options = {
      key = mkOption {
        description = "Key combination";
        default = "$mod";
        type = types.str;
      };
      command = mkOption {
        description = "Command to run";
        default = "";
        type = types.str;
      };
    };
  };

  KeyBindToCfg = binding: "bindsym ${binding.key} ${binding.command}\n";
  AllBindingToCfg = bindings: foldl' (txt: binding: txt + (KeyBindToCfg binding)) "" bindings;

  StartupItemToCfg = item: "${if item.always then "exec_always" else "exec"} ${if item.startupId then "" else "--no-startup-id "}${item.command}\n";
  AllStartupItemsToCfg = items: foldl' (txt: item: txt + (StartupItemToCfg item)) "" items;

  cfg = config.sys.desktop.tilewm;

  binDir = "/run/current-system/sw/bin";

in {
  options.sys.desktop.tilewm = {
    startup = mkOption {
      description = "List of programs to startup with window manager regardless of compositor type";
      type = types.listOf startupProgramType;
      default = [
        { command = "desktop wallpaper"; }
        { command = "systemctl --user restart gpg-agent.service"; }
      ];
    };

    startupWayland = mkOption {
      description = "List of programs to startup with wayland window manager.";
      type = types.listOf startupProgramType;
      default = [
        { command = "pkill kanshi; exec kanshi"; always = true; }
        { command = "pkill waybar; waybar"; always = true; }
      ];
    };

    modKey = mkOption {
      description = "Set the mod key used for keyboard shortcuts";
      type = types.enum ["Mod1" "Mod2" "Mod3" "Mod4"];
      default = "Mod4";
    };

    startupXorg = mkOption {
      description = "List of programs to startup with xorg window manager";
      type = types.listOf startupProgramType;
      default = [
        { command = "/run/current-system/sw/bin/autorandr -c"; always = true; }
        { command = "/run/current-system/sw/bin/xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'"; always = true; }
      ];
    };

    keyBindings = mkOption {
      description = "List of keybinds to apply to all window managers";
      type = types.listOf keybindingType;
      default = [
        { key = "$mod+1"; command = "workspace 1"; }
        { key = "$mod+2"; command = "workspace 2"; }
        { key = "$mod+3"; command = "workspace 3"; }
        { key = "$mod+4"; command = "workspace 4"; }
        { key = "$mod+5"; command = "workspace 5"; }
        { key = "$mod+6"; command = "workspace 6"; }
        { key = "$mod+7"; command = "workspace 7"; }
        { key = "$mod+8"; command = "workspace 8"; }
        { key = "$mod+9"; command = "workspace 9"; }
        { key = "$mod+Shift+1"; command = "move container to workspace 1"; }
        { key = "$mod+Shift+2"; command = "move container to workspace 2"; }
        { key = "$mod+Shift+3"; command = "move container to workspace 3"; }
        { key = "$mod+Shift+4"; command = "move container to workspace 4"; }
        { key = "$mod+shift+5"; command = "move container to workspace 5"; }
        { key = "$mod+shift+6"; command = "move container to workspace 6"; }
        { key = "$mod+shift+7"; command = "move container to workspace 7"; }
        { key = "$mod+shift+8"; command = "move container to workspace 8"; }
        { key = "$mod+shift+9"; command = "move container to workspace 9"; }
        { key = "$mod+Left"; command = "focus left"; }
        { key = "$mod+Right"; command = "focus right"; }
        { key = "$mod+Up"; command = "focus up"; }
        { key = "$mod+Down"; command = "focus down"; }
        { key = "$mod+Shift+Left"; command = "move left"; }
        { key = "$mod+Shift+Right"; command = "move right"; }
        { key = "$mod+Shift+Up"; command = "move up"; }
        { key = "$mod+Shift+Down"; command = "move down"; }
        { key = "$mod+Shift+q"; command = "kill"; }
        { key = "$mod+d"; command = "exec ${binDir}/rofi -show drun"; }
        { key = "$mod+f"; command = "fullscreen toggle"; }
        { key = "$mod+h"; command = "split h"; }
        { key = "$mod+v"; command = "split v"; }
        { key = "$mod+o"; command = "exec wks run orgSys obsidian"; }
        { key = "$mod+space"; command = "floating toggle"; }
        { key = "$mod+w"; command = "exec wks run browsers firefox"; }
        { key = "$mod+XF86AudioLowerVolume"; command = "exec ${binDir}/desktop voldown"; }
        { key = "$mod+XF86AudioMute"; command = "exec ${binDir}/desktop volmute"; }
        { key = "$mod+XF86AudioRaiseVolume"; command = "exec ${binDir}/desktop volup"; }
        { key = "$mod+Print"; command = "exec ${binDir}/desktop screenshot"; }
        { key = "$mod+Escape"; command = "exec ${binDir}/desktop lock"; }
      ];
    };

    keyBindingsWayland = mkOption {
      description = "List of keybinds to apply to wayland window managers";
      type = types.listOf keybindingType;
      default = [
        { key = "$mod+Shift+r"; command = "reload"; }
        { key = "$mod+Return"; command = "exec ${binDir}/foot"; }
      ];
    };

    keyBindingsXorg = mkOption {
      description = "List of keybinds to apply to xorg window managers";
      type = types.listOf keybindingType;
      default = [
        { key = "$mod+Return"; command = "exec ${binDir}/alacritty"; }
        { key = "$mod+Shift+r"; command = "restart"; }
      ];
    };

    extraConfig = mkOption {
      description = "Extra config to apply to both i3 and sway";
      type = types.lines;
      default = "";
    };

    extraConfigSway = mkOption {
      description = "Extra config to apply to sway";
      type = types.lines;
      default = "";
    };

    extraConfigi3 = mkOption {
      description = "Extra config to apply to i3";
      type = types.lines;
      default = "";
    };
  };


  config = mkIf desktopMode {

    sys.desktop.tilewm.extraConfig = ''
      # Extra Config
      set $mod ${cfg.modKey}
      gaps inner 20
      gaps outer -4

      font pango:monospace 8.000000
      floating_modifier $mod
      default_border pixel 2
      default_floating_border pixel 2
      hide_edge_borders none
      focus_on_window_activation smart
      mouse_warping output
      workspace_layout default
      workspace_auto_back_and_forth no
      focus_on_window_activation smart
      mouse_warping output
      workspace_layout default
      workspace_auto_back_and_forth no
      mouse_warping none
      smart_gaps on
      for_window [class="(?i)firefox" instance="^(?!Navigator$)"] floating enable
      for_window [title="i3_help"] floating enable sticky enable border normal
      for_window [class="Lightdm-gtk-greeter-settings"] floating enable
      for_window [class="Lxappearance"] floating enable sticky enable border
      for_window [class="Pavucontrol"] floating enable
      for_window [class="qt5ct"] floating enable sticky enable border normal

      floating_minimum_size 500 x 300
      floating_maximum_size 2000 x 1500
      # Theme colors
      client.focused #56737a #1e1e20 #56737a #56737a #56737a
      client.focused_inactive #56737a #1e1e20 #56737a #2c5159 #2c5159
      client.unfocused #56737a #1e1e20 #56737a #2c5159 #2c5159
      client.urgent #56737a #1e1e20 #56737a #2c5159 #2c5159
      client.placeholder #56737a #1e1e20 #56737a #2c5159 #2c5159
      client.background #1e1e20
      default_border pixel 2

      # Startup Programs
      ${AllStartupItemsToCfg cfg.startup}

      # Key bindings
      ${AllBindingToCfg cfg.keyBindings}
    '';

    sys.desktop.tilewm.extraConfigSway = ''
      # Extra Wayland Config
      focus_wrapping no

      # Wayland Startup Programs
      ${AllStartupItemsToCfg cfg.startupWayland}

      # Wayland Key Bindings
      ${AllBindingToCfg cfg.keyBindingsWayland}
    '';

    sys.desktop.tilewm.extraConfigi3 = ''
      # Extra Xorg Config
      new_window pixel 1
      force_focus_wrapping no
      new_float normal

      bar {
        
        font pango:monospace 8.000000
          
        position top
        status_command /run/current-system/sw/bin/i3blocks -c ~/.config/i3/i3blocks.conf
        i3bar_command /run/current-system/sw/bin/i3bar
      }

      # xorg Startup Programs 
      ${AllStartupItemsToCfg cfg.startupXorg}

      # xorg Key Bindings
      ${AllBindingToCfg cfg.keyBindingsXorg}
    '';
  };

}
