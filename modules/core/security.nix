{pkgs, config, lib, ...}:
with lib;
with builtins;
let
  cfg = config.sys.security;
  desktopMode = if ((length config.sys.graphics.desktopProtocols) > 0) then true else false;
in {

  options.sys.security = {
    username = mkOption {
      type = types.str;
      description = "User name of main user of the system";
    };

    sshPublicKey = mkOption {
      type = types.str;
      description = "Public SSH Keys used for ssh connections to this machine";
    };

    yubikey = mkEnableOption "Enable Yubikey support on this system";

    secrets = mkOption {
      type = types.attrs;
      description = "Store secrets in this attribute in the git crypt layer.";
      default = {};
    };
  };

  config = {
    # Stops sudo from timing out.
    security.sudo.extraConfig = "Defaults env_reset,timestamp_timeout=-1";
    security.sudo.execWheelOnly = true;

    # Enable SSHD
    services.openssh.enable = true;
    networking.firewall.allowedTCPPorts = [ 22 ];
    networking.firewall.allowPing = true;

    users.users."${cfg.username}".openssh.authorizedKeys.keys = [ cfg.sshPublicKey ];
    users.users.root.openssh.authorizedKeys.keys = [ cfg.sshPublicKey ];

    environment.systemPackages = with pkgs; [
      (mkIf cfg.yubikey gnupg)
      (mkIf cfg.yubikey yubikey-personalization)
      (mkIf cfg.yubikey yubioath-desktop)
      (mkIf cfg.yubikey pinentry-qt)
    ];

    services.gnome.gnome-keyring.enable = desktopMode;
    environment.pathsToLink = [ "/share/accountsservice" ];
    services.accounts-daemon.enable = true;

    services.pcscd.enable = cfg.yubikey;
    services.udev.packages = [ 
      (mkIf cfg.yubikey pkgs.yubikey-personalization)
    ];

    programs = mkIf cfg.yubikey {
      ssh.startAgent = false;
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
        pinentryFlavor = "qt";
      };
    };
  };
}
