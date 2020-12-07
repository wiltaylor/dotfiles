{pkgs, config, lib, ...}:
{
  home.packages = with pkgs; [
    nerdfonts
  ];

  home.file = {
    ".config/fontconfig/fonts.conf".text = ''
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
}
