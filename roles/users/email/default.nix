{pkgs, lib, config, fetchFromGitHub, ...}:
let
  mailPkg = pkgs.writeScriptBin "mail" ''
    tmux has-session -t mail 2>/dev/null

    if [ $? != 0 ]; then

      if [ "$1" == "--quiet" ]; then
        tmux new -A -d -s mail 'protonmail-bridge -c' \; new-window 'offlineimap' \; new-window 'neomutt'
        sleep 10
      else
        tmux new -A -s mail 'protonmail-bridge -c' \; new-window 'offlineimap' \; new-window 'neomutt'
      fi
    else
      
      if [ "$1" != "--quiet" ]; then
        tmux attach -t mail
      fi
    fi
  '';

  mailKillPkg = pkgs.writeScriptBin "kill-mail" ''
    tmux kill-session -t mail
  '';

  inboxScript = pkgs.writeScriptBin "ibx" ''
    mail --quiet
    msg=""
    case $1 in
      "")
        tmpfile=$(mktemp /tmp/ibxnote.XXXXXXXXXXXX)
        $EDITOR $tmpfile

        msg=$(cat $tmpfile)
        rm $tmpfile
      ;;

      *)
        msg=$1
      ;;
    esac

    if [ "$msg" == "" ]; then
      exit
    fi

    subject=$(echo "$msg" | sed -n 1p)

    mailfile=$(mktemp /tmp/email.XXXXXXXXXXXXXX)

    echo "Content-Type: multipart/mixed; boundary=3e5f370e7da8f46d5ba10df03ce0fdfaa6fb972b530afc844a0f576418661daa" > $mailfile
    echo "To: note@wiltaylor.dev" >> $mailfile
    echo "From: note@wiltaylor.dev" >> $mailfile
    echo "Subject: $subject" >> $mailfile
    echo "" >> $mailfile
    echo "--3e5f370e7da8f46d5ba10df03ce0fdfaa6fb972b530afc844a0f576418661daa" >> $mailfile
    echo "Content-Transfer-Encoding: quoted-printable" >> $mailfile
    echo "Content-Type: text/plain; charset=UTF-8" >> $mailfile
    echo "Mime-Version: 1.0" >> $mailfile
    echo "" >> $mailfile
    echo "$msg" >> $mailfile
    echo "--3e5f370e7da8f46d5ba10df03ce0fdfaa6fb972b530afc844a0f576418661daa--" >> $mailfile

    cat $mailfile | msmtp -a default note@wiltaylor.dev

    rm $mailfile

    echo "Message sent"
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
    inboxScript
  ];
  

  home.file = {
    ".config/neomutt/neomuttrc".text = ''
      # "+" substitutes for `folder`
      set mbox_type=Maildir
      set folder="~/.mail/"
      set spoolfile=+INBOX
      set record=+Sent
      set postponed=+Drafts
      set trash=+Trash
      set mail_check=2 # seconds
      set sort=reverse-date-received

      # smtp
      set sendmail = "msmtp -a default"
      set ssl_force_tls = yes
      set ssl_starttls = yes
      set ssl_verify_host = no
    '';
  };
}
