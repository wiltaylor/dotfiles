{pkgs, lib, config, ...}:
with pkgs;
with lib;
with builtins;
let
    cfg = config.sys;
in {
    sys.user.userRoles.development = [
        (user: user // {
            software = [
                git
                git-crypt
                ansible
                terraform
                consul
                nomad
                vault
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
            };
        })
    ];
}
