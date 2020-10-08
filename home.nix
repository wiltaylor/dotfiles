{ config, pkgs, lib, ... }:

{

  imports = [
    ./config/gpg.nix
    ./config/keyboard_mouse.nix
    ./config/spotify.nix
    ./config/dunst.nix
  ];

  # Nix and home manager settings
  nixpkgs.overlays = import ./packages;
  nixpkgs.config.allowUnfree = true;
  services.lorri.enable = true;
  home.username = "wil";
  home.homeDirectory = "/home/wil";

  systemd.user.startServices = true;

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
    direnv
    virt-manager
    xorg.xmodmap
    xmousepasteblock
    vscodium
    my.vscodium-alias

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
    zip
    unzip
    file
    p7zip
    mpv
    ueberzug
    ranger
  ];

  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ nerdtree nerdtree-git-plugin nord-vim vim-devicons vim-nerdtree-syntax-highlight vimwiki ];
    settings = { ignorecase = true; };
    extraConfig = ''
      " Basic editor config
      set clipboard+=unnamedplus
      set mouse=a
      set encoding=utf-8
      set number
      set noswapfile
      set nobackup
      set nowritebackup
      set tabstop=2
      set shiftwidth=2
      set softtabstop=2
      set expandtab
      set ai "Auto indent
      set si "Smart indent 
      set pyxversion=3 "Avoid using python 2 when possible, its eol 

      " No annoying sound on errors
      set noerrorbells
      set novisualbell
      set t_vb=
      set tm=500

      "Colour theme
      colorscheme nord
      let g:lightline = { 'colorscheme': 'nord', }

      "Nerd tree config
      map <C-n> :NERDTreeToggle<CR>
      let NERDTreeShowHidden=1

      "COC settings
      map <a-cr> :CocAction<CR>

      "Vim wiki settings
      let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.wiki'}]
    '';
  };

  home.sessionVariables = {

    EDITOR = "${pkgs.neovim}/bin/nvim";
  };

  services.syncthing = {
    enable = true;
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

      eval "$(direnv hook zsh)"
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
      signByDefault = false;
    };
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

  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    escapeTime = 0;
    aggressiveResize = true;
    keyMode = "vi";
    shortcut = "a";

    extraConfig = ''
setw -g mouse on
    '';
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
      "${modifier}+shift+w" = "exec ${pkgs.firefox}/bin/firefox -p vygo";
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
new_window pixel 1
new_float normal

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

# Theme colors
client.focused #56737a #1e1e20 #56737a #56737a #56737a
client.focused_inactive #56737a #1e1e20 #56737a #2c5159 #2c5159
client.unfocused #56737a #1e1e20 #56737a #2c5159 #2c5159
client.urgent #56737a #1e1e20 #56737a #2c5159 #2c5159
client.placeholder #56737a #1e1e20 #56737a #2c5159 #2c5159

client.background #1e1e20
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
  };

  services.polybar = {
    enable = true;
    script = "polybar -q -r top1 & polybar -q -r top2 & polybar -q -r top3 & polybar -q -r top4 & polybar -q -r top5 & polybar -q -r top6 &";
  
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
	  menu-3-0-exec = "i3-msg exit";
	  menu-3-1 = "cancel";
	  menu-3-1-exec = "menu-open-0";
	};

    };

  };
}
