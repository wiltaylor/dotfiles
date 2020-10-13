{pkgs, config, lib, ...}:
with lib;
let
  cfg = config.wil.git;
in {
  options.wil.git = {
    enable = mkEnableOption "Enable Git";
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      git
      git-crypt
    ];


    programs.git = {
      enable = true;
      userName  = "Wil Taylor";
      userEmail = "cert@wiltaylor.dev";
      signing = {
        key = "0xEC571018542D2ACC";
        signByDefault = true;
      };
    };    
  };
}
