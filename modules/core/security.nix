{pkgs, config, lib, ...}:
with lib;
with builtins;
let
  cfg = config.sys.security;
  desktopMode = if ((length config.sys.hardware.graphics.desktopProtocols) > 0) then true else false;
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

    gpgKeyId = mkOption {
      type = types.str;
      description = "id of gpg key";
    };
  };

  config = {
    users.users."${cfg.username}".openssh.authorizedKeys.keys = [ cfg.sshPublicKey ];
    users.users.root.openssh.authorizedKeys.keys = [ cfg.sshPublicKey ];

    services.gnome.gnome-keyring.enable = desktopMode;
    environment.pathsToLink = [ "/share/accountsservice" ];
    services.accounts-daemon.enable = true;

    sys.users.primaryUser.files = {
      gpg = {
        path = ".gnupg/gpg.conf";
        text = ''
          personal-cipher-preferences AES256 AES192 AES
          personal-cipher-preferences AES256 AES192 AES
          personal-digest-preferences SHA512 SHA384 SHA256
          personal-compress-preferences ZLIB BZIP2 ZIP Uncompressed
          default-preference-list SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed
          cert-digest-algo SHA512
          s2k-digest-algo SHA512
          s2k-cipher-algo AES256
          charset utf-8
          fixed-list-mode
          no-comments
          no-emit-version
          keyid-format 0xlong
          list-options show-uid-validity
          verify-options show-uid-validity
          with-fingerprint
          require-cross-certification
          no-symkey-cache
          use-agent
          throw-keyids

          #Trust Own GPG Key
          trusted-key ${cfg.gpgKeyId}
          default-key ${cfg.gpgKeyId}
        '';
      };

        gpgAgent = {
            path = ".gnupg/gpg-agent.conf";
            text = ''
                pinentry-program /run/current-system/sw/bin/pinentry-qt
            '';
        };
    };

    system.activationScripts = {
      gpgpubKey.text = mkIf cfg.yubikey ''
        ${pkgs.gnupg}/bin/gpg --import ${./public.asc}
      '';
    };
  };
}
