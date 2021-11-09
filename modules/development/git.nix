{pkgs, lib, config, ...}:
with lib;
with builtins;
let
  cfg = config.sys.development.git;
in {
  options.sys.development.git = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable git";
    };

    username = mkOption {
      type = types.str;
      default = "Wil Taylor";
      description = "Git display name";
    };

    email = mkOption {
      type = types.str;
      default = "cert@wiltaylor.dev";
      description = "Git email address";
    };

    signingKey = mkOption {
      type = types.str;
      default = "0xEC571018542D2ACC";
      description = "GPG Key to use when signing commits";
    };

    signCommits = mkOption {
      type = types.bool;
      default = false;
      description = "Do you want to sign GPG commits by default";
    };

    defaultBranch = mkOption {
      type = types.str;
      default = "master";
      description = "What do you want to set the default master branch to.";
    };
  };

  config = mkIf cfg.enable {
    sys.users.primaryUser.files.gitconfig = {
      path = ".config/git/config";
      text = ''
        [commit]
          gpgSign = ${if cfg.signCommits then "true" else "false"}
        [gpg]
          program = "gpg2"
        [init]
          defaultBranch = "${cfg.defaultBranch}"
        [user]
          email = "${cfg.email}"
          name = "${cfg.username}"
          signingKey = "${cfg.signingKey}"
      '';
    };
  };
}
