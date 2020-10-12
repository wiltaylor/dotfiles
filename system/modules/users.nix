{config, pkgs, lib, ...}:
with lib;
let
  cfg = config.wil.users;
in {
  options.wil.users = {
    default = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Set to false to prevent creation of default wil user accoun.
      '';
    };

    disableSudoTimeout = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Set to only prompt user with sudo password on the first time.
      '';
    };

    enableOhMyZsh = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable ohmyzsh at the system level.
      '';
    };
  };

  config = mkIf(cfg.default) {
    
    programs.zsh.enable = true;
    programs.zsh.ohMyZsh.enable = cfg.enableOhMyZsh;

    users.users.wil= {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "libvirtd" ]; 
      uid = 1000;
      shell = pkgs.zsh; 
    };

    security.sudo.extraConfig = mkIf cfg.disableSudoTimeout ("Defaults env_reset,timestamp_timeout=-1");
  };
}
