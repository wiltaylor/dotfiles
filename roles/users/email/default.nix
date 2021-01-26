{pkgs, lib, config, fetchFromGitHub, ...}:
let
  mailPkg = pkgs.writeScriptBin "mail" ''
    tmux has-session -t mail 2>/dev/null

    if [ $? != 0 ]; then

      if [ "$1" == "--quiet" ]; then
        tmux new -A -d -s mail 'protonmail-bridge -c' \; split-window 'offlineimap' \; rename-window 'Status' \;  new-window -n 'Mail' 'neomutt'
        sleep 10
      else
        tmux new -A -s mail 'protonmail-bridge -c' \; split-window 'offlineimap' \; rename-window 'Status' \; new-window -n 'Mail' 'neomutt'
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
    ".config/neomutt/mailcap".text = ''
      text/html; firefox %s
    '';

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

      set sidebar_visible = yes
      set sidebar_on_right = yes
      set sidebar_width = 20
      set sidebar_non_empty_mailbox_only = no
      set sidebar_divider_char = '|'
      set mail_check_stats
      set sidebar_format = '%B%?F? [%F]?%* %?N?%N/?%S'
      set sidebar_sort_method = 'unsorted'
      set date_format="%y/%m/%d %I:%M%p"
      set mailcap_path="~/.config/neomutt/mailcap"

      auto_view text/html
      alternative_order text/plain text/enriched text/html

      named-mailboxes "INBOX" "+INBOX"
      named-mailboxes "Archive" "+Archive"
      named-mailboxes "Sent" "+Sent"
      named-mailboxes "Drafts" "+Drafts"
      named-mailboxes "Spam" "+Spam"
      named-mailboxes "Trash" "+Trash"

      unbind index \Cb
      unbind index \Cf
      unbind index <Enter>
      unbind index <Return>
      unbind index \Cn
      unbind index \Cp 
      unbind index \r 
      unbind index \t
      unbind index \Cd
      unbind index \Cu
      unbind index <Tab>
      unbind index <Esc><Tab>
      unbind index <Esc>C
      unbind index <Esc>P
      unbind index <Esc>V
      unbind index <Esc>b
      unbind index <Esc>c
      unbind index <Esc>d
      unbind index <Esc>e
      unbind index <Esc>i
      unbind index <Esc>k
      unbind index <Esc>l
      unbind index <Esc>n
      unbind index <Esc>p
      unbind index <Esc>r
      unbind index <Esc>s
      unbind index <Esc>t
      unbind index <Esc>u
      unbind index <Esc>v
      unbind index <Space>
      unbind index #
      unbind index $
      unbind index %
      unbind index &
      unbind index .
      unbind index @
      unbind index A 
      unbind index C
      unbind index D
      unbind index F
      unbind index G
      unbind index J
      unbind index K
      unbind index L
      unbind index M
      unbind index d
      unbind index f
      unbind index g
      unbind index r
      unbind index u
      unbind index y  

      unbind generic \Cl
      unbind generic <Esc>/
      unbind generic <Down>
      unbind generic <Up>
      unbind generic <Left>
      unbind generic <Right>

      bind index,pager \Ck sidebar-prev
      bind index,pager \Cj sidebar-next
      bind index,pager \Cl sidebar-open
      bind index,pager \Ch sidebar-open
      bind index,pager r reply
      bind index,pager g group-reply
      bind index,pager f forward-message
      bind index,pager m mail
      bind index d delete-message
      bind index u undelete-message
      bind generic <Enter> select-entry
      bind generic : enter-command
      bind index M show-log-messages
      bind index <Space> sync-mailbox

      unset confirmappend
      macro index a "<save-message>=Archive<enter><enter-command>echo 'Moved to archive'<enter>"
      macro index i "<save-message>=INBOX<enter><enter-command>echo 'Moved to Inbox'<enter>"
    '';
  };
}
