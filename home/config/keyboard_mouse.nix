{pkgs, lib, config, ...}:
{
  systemd.user.services.xmousepasteblock = {
    Service = {
      ExecStart = "${pkgs.xmousepasteblock}/bin/xmousepasteblock";
      Restart = "always";
      RestartSec = 6;
    };

    Unit = {
      After = "graphical-session-pre.target";
      Description = "Tool that disables middle click paste in xorg.";
      PartOf = "graphical-session.target";
    };
    
    Install = {
      WantedBy = ["default.target"];
    };
  };

}
