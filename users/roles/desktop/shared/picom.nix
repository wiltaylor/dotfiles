{pkgs, config, lib, ...}:
{
  home.packages = with pkgs; [
    picom
  ];

  services.picom = {
    enable = true;
    fade = true;
    fadeDelta = 5;
    shadow = false;
    backend = "glx";
  };
}
