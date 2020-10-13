{pkgs, lib, config, ...}:
with lib;
let 
  cfg = config.wil.blockselection;
in {
  
  options.wil.blockselection = {
    enable = mkEnableOption "Block X selection from having content and pasting all over the place";
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      xmousepasteblock
    ];

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
  };
}
