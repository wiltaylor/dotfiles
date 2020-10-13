{pkgs, config, lib, ...}:
with lib;
let
  cfg = config.wil.zsh;
in {
  options.wil.zsh = {
    enable = mkEnableOption "Enable zsh";
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      nix-zsh-completions
      oh-my-zsh
    ];

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      initExtraBeforeCompInit = ''
        export GPG_TTY=$(tty)
        export PGP_KEY_ID=0xEC571018542D2ACC
        gpg-connect-agent updatestartuptty /bye > /dev/null
        export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

        reset-gpg() {
          export GPG_TTY=$(tty)
	        killall gpg-agent
	        rm -r ~/.gnupg/private-keys-v1.d
	        gpg-connect-agent updatestartuptty /bye
	        gpg-connect-agent "learn --force" /bye
          export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
        }

        eval "$(direnv hook zsh)"
      '';

      oh-my-zsh = {
        enable = true;
        plugins = ["git" "sudo" "docker"];
        theme = "robbyrussell";
      }; 
    };
  };
}
