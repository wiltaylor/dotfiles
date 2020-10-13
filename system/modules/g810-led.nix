# __          ___ _   _______          _
# \ \        / (_) | |__   __|        | |
#  \ \  /\  / / _| |    | | __ _ _   _| | ___  _ __
#   \ \/  \/ / | | |    | |/ _` | | | | |/ _ \| '__|
#    \  /\  /  | | |    | | (_| | |_| | | (_) | |
#     \/  \/   |_|_|    |_|\__,_|\__, |_|\___/|_|
#                                 __/ |
#                                |___/
# Web: https://wil.dev
# Github: https://github.com/wiltaylor
# Contact: web@wiltaylor.dev
# Feel free to use this configuration as you wish.
{ config, pkgs, lib, ... }:
with lib;

let 
  cfg = config.wil.hardware.g810led;

in {

  options.wil.hardware.g810led = {
    enable = mkEnableOption "Enable G810 Keyboard led control";

    package = mkOption {
      type = types.package;
      default = pkgs.wil.g810-led;
      defaultText = "pkgs.wil.g810-led";
      description = "G810 package to use";
    };
  };

  config = mkIf (cfg.enable) {

    environment.systemPackages = [ cfg.package ];

    services.udev = {
      extraRules = ''
        ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c336", MODE="666" RUN+="${cfg.package}/bin/g213-led -p ${cfg.package}/etc/g810-led/samples/group_keys"
        ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c330", MODE="666" RUN+="${cfg.package}/bin/g410-led -p ${cfg.package}/etc/g810-led/samples/group_keys"
        ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c33a", MODE="666" RUN+="${cfg.package}/bin/g413-led -p ${cfg.package}/etc/g810-led/samples/group_keys"
        ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c342", MODE="666" RUN+="${cfg.package}/bin/g512-led -p ${cfg.package}/etc/g810-led/samples/group_keys"
        ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c33c", MODE="666" RUN+="${cfg.package}/bin/g513-led -p ${cfg.package}/etc/g810-led/samples/group_keys"
        ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c333", MODE="666" RUN+="${cfg.package}/bin/g610-led -p ${cfg.package}/etc/g810-led/samples/group_keys"
        ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c338", MODE="666" RUN+="${cfg.package}/bin/g610-led -p ${cfg.package}/etc/g810-led/samples/group_keys"
        ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c331", MODE="666" RUN+="${cfg.package}/bin/g810-led -p ${cfg.package}/etc/g810-led/samples/group_keys"
        ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c337", MODE="666" RUN+="${cfg.package}/bin/g810-led -p ${cfg.package}/etc/g810-led/samples/group_keys"
        ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c33f", MODE="666" RUN+="${cfg.package}/bin/g815-led -p ${cfg.package}/etc/g810-led/samples/group_keys"
        ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c32b", MODE="666" RUN+="${cfg.package}/bin/g910-led -p ${cfg.package}/etc/g810-led/samples/group_keys"
        ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c335", MODE="666" RUN+="${cfg.package}/bin/g910-led -p ${cfg.package}/etc/g810-led/samples/group_keys"
        ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c339", MODE="666" RUN+="${cfg.package}/bin/gpro-led -p ${cfg.package}/etc/g810-led/samples/group_keys"
        ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c336", MODE="666" RUN+="${cfg.package}/bin/g213-led -p ${cfg.package}/etc/g810-led/samples/group_keys"
        ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c330", MODE="666" RUN+="${cfg.package}/bin/g410-led -p ${cfg.package}/etc/g810-led/samples/group_keys"
        ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c33a", MODE="666" RUN+="${cfg.package}/bin/g413-led -p ${cfg.package}/etc/g810-led/samples/group_keys"
        ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c342", MODE="666" RUN+="${cfg.package}/bin/g512-led -p ${cfg.package}/etc/g810-led/samples/group_keys"
        ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c33c", MODE="666" RUN+="${cfg.package}/bin/g513-led -p ${cfg.package}/etc/g810-led/samples/group_keys"
        ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c333", MODE="666" RUN+="${cfg.package}/bin/g610-led -p ${cfg.package}/etc/g810-led/samples/group_keys"
        ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c338", MODE="666" RUN+="${cfg.package}/bin/g610-led -p ${cfg.package}/etc/g810-led/samples/group_keys"
        ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c331", MODE="666" RUN+="${cfg.package}/bin/g810-led -p ${cfg.package}/etc/g810-led/samples/group_keys"
        ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c337", MODE="666" RUN+="${cfg.package}/bin/g810-led -p ${cfg.package}/etc/g810-led/samples/group_keys"
        ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c32b", MODE="666" RUN+="${cfg.package}/bin/g910-led -p ${cfg.package}/etc/g810-led/samples/group_keys"
        ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c335", MODE="666" RUN+="${cfg.package}/bin/g910-led -p ${cfg.package}/etc/g810-led/samples/group_keys"
        ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c339", MODE="666" RUN+="${cfg.package}/bin/gpro-led -p ${cfg.package}/etc/g810-led/samples/group_keys"
      '';

    };

    systemd.services.g810-led = {
      description = "Set Logitech G810 Led Profile";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/g810-led -p ${cfg.package}/etc/g810-led/samples/group_keys";
        Type = "oneshot";
        RemainAfterExit = "yes";
      };
    };

    systemd.services.g810-led-reboot = {
      description = "Set G810 profile on shutown";
      wantedBy = [ "shutdown.target" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "yes";
        ExecStart = "${cfg.package}/bin/g810-led -p ${cfg.package}/etc/g810-led/sampels/all_off";
        Before = ["shutdown.target" "reboot.target" "halt.target" ];
        DefaultDependencies = "no";
      };
    };


    environment.etc = {
      "/etc/g810-led/group_keys".source = "${cfg.package}/etc/g810-led/samples/group_keys";
      "/etc/g810-led/reboot".source = "${cfg.package}/etc/g810-led/sampels/all_off";
    };
  };
}


