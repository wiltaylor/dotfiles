{config, pkgs, lib, ...}:
with lib;
let 
  dockedPkg = pkgs.writeTextFile {
    name = "amplifier-docked";
    text = readFile ./docked.conf;
    destination = "/docked.conf";
  };

  standalonePkg = pkgs.writeTextFile {
    name = "amplifier-undocked";
    text = readFile ./standalone.conf;
    destination = "/standalone.conf";
  };

  script = pkgs.writeTextFile {
    name = "amplifier-detect";
    text = ''
      if [ -d "/sys/bus/pci/devices/0000:02:00.0" ]; then
        ln -sf ${dockedPkg}/docked.conf /etc/X11/xorg.conf.d/amplifier.conf
      else
        ln -sf ${standalonePkg}/standalone.conf /etc/X11/xorg.conf.d/amplifier.conf
      fi
    '';
    destination = "/detect";
    executable = true;
  };

in {
  systemd.services.alienware-amplifier = {
    description = "Alienware amplifier screen profile selector";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart= "${pkgs.bash}/bin/bash ${script}/detect";
    };
  };
}
