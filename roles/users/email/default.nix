{pkgs, lib, config, fetchFromGitHub, ...}:
{
  home.packages = with pkgs; [
    neomutt
    taskwarrior
    timewarrior
    tasksh
    protonmail-bridge
    offlineimap 
    notmuch
    msmtp
  ];
  

  home.file = {
    ".secrets/mail".source = ../../../.secret/email/mail;
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
      source ~/.secrets/mail
      set smtp_url=smtp://$my_email@127.0.0.1:1025
      set smtp_pass = $my_pass
      set ssl_force_tls = yes
      set ssl_starttls = yes
      set ssl_verify_host = no
    '';


    ".offlineimaprc".source = ../../../.secret/email/offlineimaprc;
  };
}
