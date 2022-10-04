{pkgs, config, lib, ...}:
with pkgs;
with lib;
let
    cfg = config.sys;
in {
    options.sys.security = {
        yubikey = mkEnableOption "Enable Yubikey support on this system";
    };

    config = mkIf cfg.security.yubikey {
        sys.software = [
            gnupg
            yubikey-personalization
            yubioath-desktop
            pinentry-qt
        ];

        services.pcscd.enable = true;
        services.udev.packages = [ yubikey-personalization ];

        programs = {
            ssh.startAgent = false;
            gnupg.agent = {
                enable = true;
                enableSSHSupport = true;
                pinentryFlavor = "qt";
            };
        };


    };
}
