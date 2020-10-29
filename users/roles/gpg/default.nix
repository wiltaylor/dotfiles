{pkgs, config, lib, ...}:
with lib;
{

  home.packages = with pkgs; [
    pass
    pinentry-gtk2
  ];

  home.file = {
    ".ssh/authorized_keys".source = ./authorized_keys;
    ".gnupg/gpg_agent.conf".text = ''
      enable-ssh-support
      default-cache-ttl 60
      max-cache-ttl 60
      pinentry-program /home/wil/.nix-profile/bin/pinentry-gtk-2
    '';
    ".gnupg/gpg.conf".source = ./gpg.conf;
    ".gnupg/public.key".source = ./public.key;
  };

  programs.zsh.initExtraBeforeCompInit = ''
    export GPG_TTY=$(tty)
    export GPG_KEY_ID=0xEC571018542D2ACC
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
  '';

  home.activation.gpgtrust = hm.dag.entryAfter ["LinkGeneration"] (''
    gpg --import ~/.gnupg/public.key
  '');

}
