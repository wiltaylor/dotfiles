{pkgs, lib, config, ...}:
with pkgs;
with lib;
with builtins;
let
    cfg = config.sys;
in {
    system.activationScripts = {
      gpgpubKey.text = ''
        ${pkgs.gnupg}/bin/gpg --import ${./public.asc}
      '';
    };

    sys.user.userRoles.development = [
        (user: mergeUser user {
            software = [
                git
                git-crypt
                ansible
                terraform
                consul
                nomad
                vault
                docker
                rustup
                python3Full
                zeal
                jupyter
                quickemu
                netcoredbg
                tree-sitter
                gcc
                nodejs # Needed for neovim lsp and tree sitter. Really want to remove this.
                rust-analyzer 
                bear
                clang
                llvm_14
                llvm_14.dev
                cmake
                gnumake
            ];

            files = {
                gitconfig = {
                    path = ".config/git/config";
                    text = ''
                        [commit]
                          gpgSign = "true"
                        [gpg]
                          program = "gpg2"
                        [init]
                          defaultBranch = "main"
                        [user]
                          email = "${user.config.email}"
                          name = "${user.config.name}"
                          signingKey = "${user.config.signingKey}"
                    '';
                };
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
                      trusted-key ${user.config.signingKey}
                      default-key ${user.config.signingKey}
                    '';
                };

                gpgAgent = {
                        path = ".gnupg/gpg-agent.conf";
                        text = ''
                            pinentry-program /run/current-system/sw/bin/pinentry-qt
                        '';
                };

            };
        })
    ];
}
