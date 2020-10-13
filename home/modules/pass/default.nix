{pkgs, config, lib, ...}:
with lib;
let
  cfg = config.wil.pass;
in {
  options.wil.pass = {
    enable = mkEnableOption "Unix password manager";
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      pass-otp
    ];
  };
}
