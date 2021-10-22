{ config, pkgs, lib, ... }:
with lib;

let 
  cfg = config.sys.hardware;
in {
    options.sys.hardware = {
      g810led = mkEnableOption "Enable G810 Keyboard led control";
    };

    config = let
      g810pkg = pkgs.my.g810-led;
    in {
      environment.systemPackages = [
        (mkIf (cfg.g810led) pkgs.my.g810-led)
      ];

      services.udev = mkIf cfg.g810led {
        extraRules = ''
          ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c336", MODE="666" RUN+="${g810pkg}/bin/g213-led -p ${g810pkg}/etc/g810-led/samples/group_keys"
          ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c330", MODE="666" RUN+="${g810pkg}/bin/g410-led -p ${g810pkg}/etc/g810-led/samples/group_keys"
          ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c33a", MODE="666" RUN+="${g810pkg}/bin/g413-led -p ${g810pkg}/etc/g810-led/samples/group_keys"
          ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c342", MODE="666" RUN+="${g810pkg}/bin/g512-led -p ${g810pkg}/etc/g810-led/samples/group_keys"
          ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c33c", MODE="666" RUN+="${g810pkg}/bin/g513-led -p ${g810pkg}/etc/g810-led/samples/group_keys"
          ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c333", MODE="666" RUN+="${g810pkg}/bin/g610-led -p ${g810pkg}/etc/g810-led/samples/group_keys"
          ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c338", MODE="666" RUN+="${g810pkg}/bin/g610-led -p ${g810pkg}/etc/g810-led/samples/group_keys"
          ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c331", MODE="666" RUN+="${g810pkg}/bin/g810-led -p ${g810pkg}/etc/g810-led/samples/group_keys"
          ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c337", MODE="666" RUN+="${g810pkg}/bin/g810-led -p ${g810pkg}/etc/g810-led/samples/group_keys"
          ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c33f", MODE="666" RUN+="${g810pkg}/bin/g815-led -p ${g810pkg}/etc/g810-led/samples/group_keys"
          ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c32b", MODE="666" RUN+="${g810pkg}/bin/g910-led -p ${g810pkg}/etc/g810-led/samples/group_keys"
          ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c335", MODE="666" RUN+="${g810pkg}/bin/g910-led -p ${g810pkg}/etc/g810-led/samples/group_keys"
          ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c339", MODE="666" RUN+="${g810pkg}/bin/gpro-led -p ${g810pkg}/etc/g810-led/samples/group_keys"
          ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c336", MODE="666" RUN+="${g810pkg}/bin/g213-led -p ${g810pkg}/etc/g810-led/samples/group_keys"
          ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c330", MODE="666" RUN+="${g810pkg}/bin/g410-led -p ${g810pkg}/etc/g810-led/samples/group_keys"
          ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c33a", MODE="666" RUN+="${g810pkg}/bin/g413-led -p ${g810pkg}/etc/g810-led/samples/group_keys"
          ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c342", MODE="666" RUN+="${g810pkg}/bin/g512-led -p ${g810pkg}/etc/g810-led/samples/group_keys"
          ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c33c", MODE="666" RUN+="${g810pkg}/bin/g513-led -p ${g810pkg}/etc/g810-led/samples/group_keys"
          ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c333", MODE="666" RUN+="${g810pkg}/bin/g610-led -p ${g810pkg}/etc/g810-led/samples/group_keys"
          ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c338", MODE="666" RUN+="${g810pkg}/bin/g610-led -p ${g810pkg}/etc/g810-led/samples/group_keys"
          ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c331", MODE="666" RUN+="${g810pkg}/bin/g810-led -p ${g810pkg}/etc/g810-led/samples/group_keys"
          ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c337", MODE="666" RUN+="${g810pkg}/bin/g810-led -p ${g810pkg}/etc/g810-led/samples/group_keys"
          ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c32b", MODE="666" RUN+="${g810pkg}/bin/g910-led -p ${g810pkg}/etc/g810-led/samples/group_keys"
          ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c335", MODE="666" RUN+="${g810pkg}/bin/g910-led -p ${g810pkg}/etc/g810-led/samples/group_keys"
          ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c339", MODE="666" RUN+="${g810pkg}/bin/gpro-led -p ${g810pkg}/etc/g810-led/samples/group_keys"
        '';
      };

      systemd.services.g810-led = mkIf cfg.g810led {
        description = "Set Logitech G810 Led Profile";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${g810pkg}/bin/g810-led -p ${g810pkg}/etc/g810-led/samples/group_keys";
          Type = "oneshot";
          RemainAfterExit = "yes";
        };
      };

      systemd.services.g810-led-reboot = mkIf cfg.g810led {
        description = "Set G810 profile on shutown";
        wantedBy = [ "shutdown.target" ];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = "yes";
          ExecStart = "${g810pkg}/bin/g810-led -p ${g810pkg}/etc/g810-led/sampels/all_off";
          Before = ["shutdown.target" "reboot.target" "halt.target" ];
          DefaultDependencies = "no";
        };
      };

      environment.etc = mkIf cfg.g810led {
        "/etc/g810-led/group_keys".source = "${g810pkg}/etc/g810-led/samples/group_keys";
        "/etc/g810-led/reboot".source = "${g810pkg}/etc/g810-led/sampels/all_off";
      };
    };
}
