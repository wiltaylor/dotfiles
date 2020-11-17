{pkgs, lib, config, ...}:
{
  home.packages = with pkgs; [
    neomutt
    hydroxide
  ];

  systemd.user.services.hydroxide = {
    Service = {
      ExecStart = "${pkgs.hydroxide}/bin/hydroxide serve";
      Restart = "always";
      RestartSec = 6;
    };

    Unit = {
      After = "graphical-session-pre.target";
      Description = "Protonmail Bridge service without gui crap";
      PartOf = "graphical-session.target";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  home.file = {
    ".secrets/mail".source = ../../../.secret/email/mail;
    ".config/hydroxide/auth.json".source = ../../../.secret/email/auth.json;
    ".config/neomutt/neomuttrc".source = ./neomuttrc;
  };
}
