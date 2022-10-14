{pkgs, lib, config, ...}:
with lib;
with builtins;
let
  xorg = (elem "xorg" config.sys.hardware.graphics.desktopProtocols);
  wayland = (elem "wayland" config.sys.hardware.graphics.desktopProtocols);
  desktopMode = xorg || wayland;
in {
  
  config = mkIf desktopMode {
    fonts.fonts = with pkgs; [ nerdfonts ];

    sys.users.allUsers.files = {
      fontconf = {
        path = ".config/fontconfig/fonts.conf";
        text = ''
          <?xml version="1.0"?>
          <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
          <fontconfig>
            <alias>
              <family>monospace</family>
              <prefer>
                <family>Monoid Nerd Font Mono</family>
              </prefer>
            </alias>
          </fontconfig>
        '';
      };
    };
  };
}
