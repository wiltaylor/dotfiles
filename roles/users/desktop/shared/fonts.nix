{pkgs, config, lib, ...}:
{
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
}
