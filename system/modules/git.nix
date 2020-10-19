{pkgs, config, lib, ...}:
with lib;
let
  cfg = config.wil.git;
in {
  options.wil.git =  {
    enable = mkEnableOption "Enable git";
  };

  config = mkIf (cfg.enable) {
    environment.systemPackages = with pkgs; [
      git
      git-crypt
    ];

    system.activationScripts = {
      git = ''
        git config --global user.name = "Wil Taylor"
        git config --global user.email = "cert@wiltaylor.dev"
      '';
    };
  };
}
