# __          ___ _   _______          _
# \ \        / (_) | |__   __|        | |
#  \ \  /\  / / _| |    | | __ _ _   _| | ___  _ __
#   \ \/  \/ / | | |    | |/ _` | | | | |/ _ \| '__|
#    \  /\  /  | | |    | | (_| | |_| | | (_) | |
#     \/  \/   |_|_|    |_|\__,_|\__, |_|\___/|_|
#                                 __/ |
#                                |___/
# Web: https://wil.dev
# Github: https://github.com/wiltaylor
# Contact: web@wiltaylor.dev
# Feel free to use this configuration as you wish.


{pkgs, config, lib, ...}:
with lib;
let 
  cfg = config.wil.fonts;
in {

  options.wil.fonts = {
    enable = mkEnableOption "Enable my font set";
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      powerline-fonts
      font-awesome
      font-awesome-ttf
    ];

    home.file = {
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
  };
}
