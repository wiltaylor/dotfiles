{pkgs, config, lib, ...}:
{
  home.pacakges = with pkgs; [
    picom
  ];

  services.picom = {
    enable = true;
    fade = true;
    fadeDelta = 5;
    shadow = false;
    backend = "glx";
    vsync = true;
  };
}
