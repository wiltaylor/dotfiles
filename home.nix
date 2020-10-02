{ config, pkgs, lib, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

  services.lorri.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "wil";
  home.homeDirectory = "/home/wil";

  home.packages = with pkgs; [
    alacritty
    rofi
    pavucontrol
    picom
    firefox
    nix-zsh-completions
    oh-my-zsh
    git
    git-crypt
    joplin-desktop
    spotify-tui
    spotifyd
    direnv
    virt-manager
    xorg.xmodmap
    xmousepasteblock
    tmux

    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    powerline-fonts
    font-awesome
    font-awesome-ttf

    maim
    xclip
    gimp
    libnotify
    neofetch
    htop

    breeze-gtk
    breeze-qt5
    bat
    xorg.xev
    feh
  ];

  systemd.user.services.spotifyd = {
    Service = {
      ExecStart = "${pkgs.spotifyd}/bin/spotifyd --no-daemon --config-path .config/spotifyd/config";
      Restart = "always";
      RestartSec = 6;
    };

    Unit = {
      After = "graphical-session-pre.target";
      Description = "Spotify Daemon";
      PartOf = "graphical-session.target";
    };
  };

  systemd.user.services.xmousepasteblock = {
    Service = {
      ExecStart = "${pkgs.xmousepasteblock}/bin/xmousepasteblock";
      Restart = "always";
      RestartSec = 6;
    };

    Unit = {
      After = "graphical-session-pre.target";
      Description = "Tool that disables middle click paste in xorg.";
      PartOf = "graphical-session.target";
    };
  };

  services.dunst = {
    enable = true;
    settings = {
      global = {
        font = "Source Code Pro 12";
        markup = "full";
        format = "%s\n%b";
        sort = "yes";
        indicate_hidden = "yes";
        alignment = "center";
        bounce_freq = 0;
        show_age_threshold = 60;
        word_wrap = "yes";
        ignore_newline = "no";
        geometry = "240x3-20+30";
        transparency = 10;
        idle_threshold = 120;
        monitor = 0;
        follow = "mouse";
        sticky_history = "yes";
        line_height = 0;
        separator_height = 2;
        padding = 5;
        horizontal_padding = 5;
        separator_color = "frame";
        startup_notification = true;
        show_indicators = "no";
        frame_width = 1;
        frame_color = "#000000";
      };

      shortcuts = {
        close = "ctrl+space";
        close_all = "ctrl+shift+space";
        history = "ctrl+grave";
        context = "ctrl+shift+period";
      };

      urgency_low = {
        background = "#000000";
        foreground = "#ffffff";
        timeout = 4;
      };

      urgency_normal = {
        background = "#000000";
        foreground = "#ffffff";
        timeout = 6;
      };

      urgency_critical = {
        background = "#000000";
        foreground = "#cf6a4c";
        timeout = 0;
      };

    };
  };

  # TODO: Replace this with proper nix configs.
  # Getting it all in now and slowly fixing it.
  home.file = {
    ".config/wallpapers".source = ./files/wallpapers;
    ".config/spotifyd/config".source = ./.secret/spotifyd/spotifyd.conf;
    ".config/alacritty/alacritty.yml".source = ./files/alacritty/alacritty.yml;
    ".config/fontconfig/fonts.conf".text = ''
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
 <alias>
  <family>monospace</family>
  <prefer>
    <family>DejaVu Sans Mono</family>
    <family>Noto Color Emoji</family>
    <family>Roboto Mono for Powerline</family>
    <family>Noto Emoji</family>
    <family>Font Awesome 5 Free</family>
    <family>Font Awesome 5 Brands</family>
   </prefer>
 </alias>
</fontconfig>
    '';
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    initExtraBeforeCompInit = ''
      export GPG_TTY=$(tty)
      export PGP_KEY_ID=0xEC571018542D2ACC
      gpg-connect-agent updatestartuptty /bye > /dev/null
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

      reset-gpg() {
        export GPG_TTY=$(tty)
	killall gpg-agent
	rm -r ~/.gnupg/private-keys-v1.d
	gpg-connect-agent updatestartuptty /bye
	gpg-connect-agent "learn --force" /bye
        export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      }
    '';

    oh-my-zsh = {
      enable = true;
      plugins = ["git" "sudo" "docker"];
      theme = "robbyrussell";
    }; 
  };


  programs.git = {
    enable = true;
    userName  = "Wil Taylor";
    userEmail = "cert@wiltaylor.dev";
    signing = {
      key = "0xEC571018542D2ACC";
      signByDefault = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    sshKeys = [ "8E2F0F7FC027E5EC914378BBD596B7D4B930ACA1" ];
    pinentryFlavor = "gtk2";
    enableScDaemon = true;
  };

  home.file = {
    ".ssh/authorized_keys".text = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC2u34uDlLjo6YfpgyvYTnhsUcmlANFdXEOo+jaM9R7DxNXjTVouMX06gwXvhtoKzbzqYf4OKBe+4xPA1rj/eBQenmCtzMLLCEy8JNDtx6KqdmrAZF9zlT71Y53Kl/EFFUDLEECcy6OmjkMDBLkxG6VhE3d3P39NbfXYa606dD0c6iGhZbj3iQK08Lz0Mt/S93/dQV6AfHtQDq0I/V5UwaA6vhpqFCkdqWWDxsew6IUxVXDFLLfb/ghYt4RND6c2xq2mqSwhZ9uVjUBdju0mZfgnQ616JkRGJANuE8BRUijp6LUswz1GYA7b0B7a0nKwk+VLoy6yYj8a+AX5XuREF70IeE2Kq85KmfRnumxMfAvLFDO0i9ACGyzmwFLP/tYyYyk9T4Ttdk8PM94BrlsHcFkZ3DcAtsx4H84KaWAsaZPVC+tBQFrTVS9HdJdi09L4N5+db4Cs1Fhwm69YXcSkQvNN61g3C5lYER7U7Wc4L7l1AlqxaEBdDURpGcpAjUvlRO+ZlTyUF/ZR3Qx24jMWtK3VkZdIkaV253v4TuZcDHwHub/9MnbUMydyTsp94n50WeKpAz/PHBHeB5KpE29DWNk8vmEQ134/t4S0hc6yL0vTGmlMLLOzqC0GNBBps+yamMI9xj6GVcic152+B2+mILRPC4LQu3u5nSCRaq2Qflh1Q==";

   ".gnupg/gpg-agent.conf".text = ''
# https://github.com/drduh/config/blob/master/gpg-agent.conf
# https://www.gnupg.org/documentation/manuals/gnupg/Agent-Options.html
enable-ssh-support
default-cache-ttl 60
max-cache-ttl 120
   '';

   ".gnupg/gpg.conf".text = ''
# https://github.com/drduh/config/blob/master/gpg.conf
# https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html
# https://www.gnupg.org/documentation/manuals/gnupg/GPG-Esoteric-Options.html
# Use AES256, 192, or 128 as cipher
personal-cipher-preferences AES256 AES192 AES
# Use SHA512, 384, or 256 as digest
personal-digest-preferences SHA512 SHA384 SHA256
# Use ZLIB, BZIP2, ZIP, or no compression
personal-compress-preferences ZLIB BZIP2 ZIP Uncompressed
# Default preferences for new keys
default-preference-list SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed
# SHA512 as digest to sign keys
cert-digest-algo SHA512
# SHA512 as digest for symmetric ops
s2k-digest-algo SHA512
# AES256 as cipher for symmetric ops
s2k-cipher-algo AES256
# UTF-8 support for compatibility
charset utf-8
# Show Unix timestamps
fixed-list-mode
# No comments in signature
no-comments
# No version in signature
no-emit-version
# Long hexidecimal key format
keyid-format 0xlong
# Display UID validity
list-options show-uid-validity
verify-options show-uid-validity
# Display all keys and their fingerprints
with-fingerprint
# Display key origins and updates
#with-key-origin
# Cross-certify subkeys are present and valid
require-cross-certification
# Disable caching of passphrase for symmetrical ops
no-symkey-cache
# Enable smartcard
use-agent
# Disable recipient key ID in messages
throw-keyids
#Trust own GPG key
trusted-key 0xEC571018542D2ACC
default-key 0xEC571018542D2ACC
'';

   ".gnupg/public.key".text = ''
-----BEGIN PGP PUBLIC KEY BLOCK-----

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
=bHWB
-----END PGP PUBLIC KEY BLOCK-----
   '';
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";

  services.picom = {
    enable = lib.mkDefault true;
    fade = lib.mkDefault true;
    fadeDelta = lib.mkDefault 5;
    shadow = lib.mkDefault false;
    backend = lib.mkDefault "glx";
    vSync = true;
  };

  xsession = {
    enable = true;
    windowManager.i3 = {
    	enable = true;
	package = pkgs.i3-gaps;

	config = rec {
          modifier = "Mod4";

	  startup = [
	    { command = "${pkgs.xorg.xmodmap} -e 'clear Lock' -e 'keycode 0x42 = Escape'"; }
	    { command = "${pkgs.xmousepasteblock}"; }
	    { 
	      command = "${pkgs.feh}/bin/feh --bg-fill --randomize ~/.config/wallpapers/*"; 
	      always = true;
	      notification = false;
	    }

	    { 
	      command = "~/.config/polybar/launch.sh"; 
	      always = true; 
	      notification = false;
	    }
	  ];

	  gaps = {
	    inner = 20;
	    outer = -4;
	  };

          floating = {
            modifier = "${modifier}";
          };

	  bars = [];

	  keybindings = {
	    "${modifier}+Shift+r" = "restart";
   	    "${modifier}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
	    "${modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -show drun";
	    "${modifier}+w" = "exec ${pkgs.firefox}/bin/firefox";
	    "${modifier}+Shift+q" = "kill";
	    "${modifier}+j" = "exec ${pkgs.joplin-desktop}/bin/joplin-desktop";
	    "${modifier}+Left" = "focus left";
	    "${modifier}+Right" = "focus right";
	    "${modifier}+Up" = "focus up";
	    "${modifier}+Down" = "focus down";
	    "${modifier}+shift+Left" = "move left";
	    "${modifier}+shift+Right" = "move right";
	    "${modifier}+shift+Up" = "move up";
	    "${modifier}+shift+Down" = "move down";
	    "Print" = "exec maim --format png | xclip -selection clipboard -t image/png -i";
	    "${modifier}+Print" = "exec maim -s --format png | xclip -selection clipboard -t image/png -i";


            "${modifier}+1" = "workspace 1";
            "${modifier}+2" = "workspace 2";
            "${modifier}+3" = "workspace 3";
            "${modifier}+4" = "workspace 4";
            "${modifier}+5" = "workspace 5";
            "${modifier}+6" = "workspace 6";
            "${modifier}+7" = "workspace 7";
            "${modifier}+8" = "workspace 8";
            "${modifier}+9" = "workspace 9";
            "${modifier}+0" = "workspace 10";

            "${modifier}+Shift+1" = "move container to workspace 1";
            "${modifier}+Shift+2" = "move container to workspace 2";
            "${modifier}+Shift+3" = "move container to workspace 3";
            "${modifier}+Shift+4" = "move container to workspace 4";
            "${modifier}+Shift+5" = "move container to workspace 5";
            "${modifier}+Shift+6" = "move container to workspace 6";
            "${modifier}+Shift+7" = "move container to workspace 7";
            "${modifier}+Shift+8" = "move container to workspace 8";
            "${modifier}+Shift+9" = "move container to workspace 9";
            "${modifier}+Shift+0" = "move container to workspace 10";

	    "${modifier}+f" = "fullscreen toggle";
	    "${modifier}+space" = "floating toggle";
	    "${modifier}+h" = "split h";
	    "${modifier}+v" = "split v";
	    "${modifier}+shift+minus" = "move scratchpad";
	    "${modifier}+minus" = "scratchpad show";

	    "${modifier}+l" = "exec --no-startup-id dm-tool lock";
	    "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume `pactl list short sinks | grep -m 1 RUNNING | awk '{print $1}'` +5%";
	    "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume `pactl list short sinks | grep -m 1 RUNNING | awk '{print $1}'` -5%";
	    "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute `pactl list short sinks | grep -m 1 RUNNING | awk '{print $1}'` ndtoggle";
	  };


	};
   	extraConfig = ''
smart_gaps on
for_window [class="(?i)firefox" instance="^(?!Navigator$)"] floating enable
for_window [title="i3_help"] floating enable sticky enable border normal
for_window [class="Lightdm-gtk-greeter-settings"] floating enable
for_window [class="Lxappearance"] floating enable sticky enable border
for_window [class="Pavucontrol"] floating enable
for_window [class="qt5ct"] floating enable sticky enable border normal

floating_minimum_size 500 x 300
floating_maximum_size 2000 x 1500
floating_modifier Mod4
	'';
	
    };
  };

  home.file = {
    ".config/gtk-4.0/settings.ini".source = ./files/gtk/4/settings.ini;
    ".config/gtk-3.0/settings.ini".source = ./files/gtk/3/settings.ini;
    ".config/gtk-3.0/colors.css".source = ./files/gtk/3/colors.css;
    ".config/gtk-3.0/gtk.css".source = ./files/gtk/3/gtk.css;

    ".kde4/share/config/kdeglobals".source = ./files/kde/kdeglobals;
    ".kde4/share/apps/color-schemes/Breeze.colors".source = ./files/kde/Breeze.colors;
    ".kde4/share/apps/color-schemes/BreezeDark.colors".source = ./files/kde/BreezeDark.colors;

    ".config/polybar/launch.sh" = {
    	source = ./files/polybar/launch.sh;
	executable = true;
    };
  };

  services.polybar = {
    enable = true;
    script = "polybar top1 &";
  
    package = pkgs.polybar.override {
      i3GapsSupport = true;
    };

    config = rec {
      
	templatebar = {
	  width = "100%";
	  height = "2%";
	  radius = 0;
	  background = "#1e1e20";
	  foreground = "#c5c8c6";
	  line-size = 3;
	  border-size = 0;
	  padding-left = 2;
	  padding-right = 2;
	  module-margin-left = 1;
	  module-margin-right = "0.5";

	  font-0 = "Source Code Pro Semibold:size=18;1";
	  font-1 = "Font Awesome 5 Free:style=Solid:size=18;1";
	  font-2 = "Font Awesome 5 Brands:size=18;1";
	  modules-left = "powermenu i3";
	  modules-right = "bat0 bat1 wifi0 wifi1 eth0 audio clock";
	  tray-position = "right";
	  tray-maxsize = 32;
	  cursor-click = "pointer";
	  cursor-scroll = "ns-resize";
	};

	templatewlan = {
	  type = "internal/network";
          interval = "3.0";

          format-connected = "<ramp-signal> <label-connected>";
	  format-connected-background = "#1e1e20";
	  format-connected-padding = "0.5";
	  label-connected = "%essid% %local_ip%";

	  ramp-signal-0 = " ";
	  ramp-signal-1 = " ";
	  ramp-signal-2 = " ";
	  ramp-signal-3 = " ";
	  ramp-signal-4 = " ";

	};

	templateeth = {
	  type = "internal/network";
	  interval = "3.0";

	  format-connected-padding = "2";
	  format-connected-background = "#1e1e20";
	  format-connected-prefix = " ";
	  label-connected = "%local_ip%";
	};

	templatebat = {
	  type = "internal/battery";
	  full-at = "100";
	  poll-interval = 5;
	  format-charging = "<animation-charging><label-charging>";
	  format-discharging = "<ramp-capacity><label-discharging>";
	  format-full = "<ramp-capacity><label-full>";
	  label-charging = "%percentage%%";
	  label-discharging = "%percentage%%";
	  label-full = "Full";

	  ramp-capacity-0 = " ";
	  ramp-capacity-1 = " ";
	  ramp-capacity-2 = " ";
	  ramp-capacity-3 = " ";
	  ramp-capacity-4 = " ";

	  bar-capacity-width = 10;

	  animation-charging-0 = " ";
	  animation-charging-1 = " ";
	  animation-charging-2 = " ";
	  
	  animation-charging-3 = " ";
	  animation-charging-4 = " ";
	  animation-charging-framerate = 750;

	  animation-discharging-0 = " ";
	  animation-discharging-1 = " ";
	  animation-discharging-2 = " ";
	  animation-discharging-3 = " ";
	  animation-discharging-4 = " ";
	  animation-discharging-framerate = 500;
	};

	bat0 = {
	  battery = "BAT0";
	  adapter = "AC";
	};

	bat1 = {
	  battery = "BAT1";
	  adapter = "ADP1";
	};

	wifi0 = {
	  interface = "wlp2s0";
	};

	wifi1 = {
	  interface = "wlp63s0";
	};

	eth0 = {
	  interface = "enp62s0";
	};

	dp0 = {
	  monitor = "DP-0";
	};

	dp2 = {
	  monitor = "DP-2";
	};

	dp3 = {
          monitor = "DP-4";
	};

	dp0-mini = {
          monitor = "eDP1";
	};

	dp1-mini = {
	  monitor = "DP1-1";
	};	

	dp2-mini = {
	  monitor = "DP1-2";
	};

	"bar/top1" = templatebar // dp0;
	"bar/top2" = templatebar // dp2;
	"bar/top3" = templatebar // dp3;
	"bar/top4" = templatebar // dp0-mini;
	"bar/top5" = templatebar // dp1-mini;
	"bar/top6" = templatebar // dp2-mini;

	"module/wifi0" = templatewlan // wifi0;
	"module/wifi1" = templatewlan // wifi1;
	"module/eth0" = templateeth // eth0;
	"module/bat0" = templatebat // bat0;
	"module/bat1" = templatebat // bat1;

	"module/i3" = {
	  type = "internal/i3";
	  format = "<label-state> <label-mode>";

	  label-mode-padding = 2;
	  label-mode-foreground = "#1e1e20";
	  label-mode-background = "#56737a";

	  label-focused = "%index%";
	  label-focused-background = "#2c5159";
          label-focused-foreground = "#6b7443";
          label-focused-padding = 2;

          label-unfocused = "%index%";
          label-unfocused-background = "#56737a";
          label-unfocused-foreground = "#1e1e20";
          label-unfocused-padding = 2;

          label-visible = "%index%";
          label-visible-background = "#56737a";
          label-visible-foreground = "#1e1e20";
          label-visible-padding = 2;

          label-urgent = "%index%";
          label-urgent-background = "#BA2922";
          label-urgent-padding = 2;
	};

	"global/wm" = {
	  margin-top = 0;
	  margin-bottom = 0;
	};

	"module/audio" = {
	  type = "internal/pulseaudio";
	  use-ui-max = "true";
	  format-volume = "<ramp-volume> <label-volume>";
	  label-muted = " ";
	  click-right = "pavucontrol &";

	  ramp-volume-0 = " ";
	  ramp-volume-1 = " ";
	  ramp-volume-2 = " ";
	};

	"module/clock" = {
	  type = "internal/date";
          interval = 5;

          date = "%Y-%m-%d";
          date-alt = " %Y-%m-%d";

          time = "%H:%M:%S";
          time-alt = "%H:%M:%S";

	  format-padding = 1;
	  label = " %date% %time%";
	};

	"module/powermenu" = {
	  type = "custom/menu";

	  expand-right = "true";

	  format-spacing = 1;

	  label-open = " ";
	  label-open-foreground = "#56737a";
	  label-close = " cancel";
	  label-close-foreground = "#56737a";
	  label-separator = "|";
	  label-separator-foreground = "#80969b";

	  menu-0-0 = "reboot";
	  menu-0-0-exec = "menu-open-1";
	  menu-0-1 = "power off";
	  menu-0-1-exec = "menu-open-2";
	  menu-0-2 = "log off";
	  menu-0-2-exec = "menu-open-3";

	  menu-1-0 = "reboot";
	  menu-1-0-exec = "reboot";
	  menu-1-1 = "cancel";
	  menu-1-1-exec = "menu-open-0";

	  menu-2-0 = "power off";
	  menu-2-0-exec = "poweroff";
	  menu-2-1 = "cancel";
	  menu-2-1-exec = "menu-open-0";

	  menu-3-0 = "log off";
	  menu-3-0-exec = "pkill -KILL -u $USER";
	  menu-3-1 = "cancel";
	  menu-3-1-exec = "menu-open-0";
	};

    };

  };
}
