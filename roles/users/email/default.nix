{pkgs, lib, config, fetchFromGitHub, ...}:
let
  mailPkg = pkgs.writeScriptBin "mail" ''
    tmux has-session -t mail 2>/dev/null

    if [ $? != 0 ]; then
      tmux new -A -s mail 'protonmail-bridge -c' \; new-window 'offlineimap' \; new-window 'neomutt'
    else
      tmux attach -t mail
    fi
  '';

  mailKillPkg = pkgs.writeScriptBin "kill-mail" ''
    tmux kill-session -t mail
  '';
in {




  home.packages = with pkgs; [
    neomutt
    taskwarrior
    timewarrior
    tasksh
    protonmail-bridge
    offlineimap 
    notmuch
    msmtp
    mailPkg
    mailKillPkg
  ];
  

  home.file = {
    #".secrets/mail".source = ../../../.secret/email/mail;
    #".msmtprc".source = ../../../.secret/email/msmtprc;
    #".config/hydroxide/auth.json".source = ../../../.secret/email/auth.json;
    ".config/neomutt/neomuttrc".text = ''
      # "+" substitutes for `folder`
      set mbox_type=Maildir
      set folder="~/.mail/"
      set spoolfile=+INBOX
      set record=+Sent
      set postponed=+Drafts
      set trash=+Trash
      set mail_check=2 # seconds

      # smtp
      set sendmail = "msmtp -a default"
      set ssl_force_tls = yes
      set ssl_starttls = yes
      set ssl_verify_host = no
    '';


    #".offlineimaprc".source = ../../../.secret/email/offlineimaprc;
  };
}
