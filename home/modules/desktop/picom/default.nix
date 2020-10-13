{pkgs, config, lib, ...}:
with lib;
let
  cfg = config.wil.picom;
in {
  options.wil.picom = {
    enable = mkEnableOption "Enable picom";
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      picom
    ];

    services.picom = {
      enable = lib.mkDefault true;
      fade = lib.mkDefault true;
      fadeDelta = lib.mkDefault 5;
      shadow = lib.mkDefault false;
      backend = lib.mkDefault "glx";
      vSync = true;
    };
  };
}
