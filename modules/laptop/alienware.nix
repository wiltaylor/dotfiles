{pkgs, config, lib, ...}:
with lib;
let
  cfg = config.alienware;

  # To do paramatise this out.
  dockedPkg = pkgs.writeTextFile {
    name = "amplifier-docked";
    text = ''
      Section "ServerLayout"
          Identifier     "Layout0"
          Screen      2  "Screen0"
          Screen      1  "Screen1"
          Screen      0  "Screen2"
          InputDevice    "Keyboard0" "CoreKeyboard"
          InputDevice    "Mouse0" "CorePointer"
          Option	   "Xinerama" "0"
          Option     "AllowExternalGpus" "TRUE"
          Option     "AllowNVIDIAGPUScreens" "FALSE"
          Option     "ProbeAllGpus" "FALSE"

      EndSection

      Section "Files"
      EndSection

      Section "InputDevice"
          Identifier     "Mouse0"
          Driver         "mouse"
          Option         "Protocol" "auto"
          Option         "Device" "/dev/psaux"
          Option         "Emulate3Buttons" "no"
          Option         "ZAxisMapping" "4 5"
      EndSection

      Section "InputDevice"
          Identifier     "Keyboard0"
          Driver         "kbd"
      EndSection

      Section "Monitor"
          Identifier     "Monitor0"
      EndSection

      Section "Monitor"
         Identifier      "Monitor1"
      EndSection

      Section "Monitor"
         Identifier      "Monitor2"
      EndSection

      Section "Device"
          Identifier     "Device0"
          Driver         "nvidia"
          VendorName     "NVIDIA Corporation"
          BusID	   "${cfg.busIDDocked}"
          Screen         0
      EndSection

      Section "Device"
          Identifier     "Device1"
          Driver	   "nvidia"
          VendorName     "NVIDIA Corporation"
          BusID	   "${cfg.busIDDocked}"
      EndSection

      Section "Device"
         Identifier      "Device2"
         Driver          "nvidia"
         VendorName      "NVIDIA Corporation"
         Screen          1
      EndSection

      Section "Screen"
          Identifier     "Screen0"
          Device         "Device0"
          DefaultDepth   24
          Monitor        "Monitor0"
      EndSection

      Section "Screen"
         Identifier      "Screen1"
         Device          "Device1"
         DefaultDepth    24
         Monitor         "Monitor1"
      EndSection

      Section "Screen"
         Identifier     "Screen2"
         Device         "Device2"
         DefaultDepth   24
         Monitor        "Monitor2"
      EndSection
    '';
    destination = "/docked.conf";
  };

  standalonePkg = pkgs.writeTextFile {
    name = "amplifier-undocked";
    text = ''
      Section "ServerLayout"
         Identifier      "LaptopOnly"
         Screen      0   "Screen0"
         InputDevice     "Keyboard0" "CoreKeyboard"
         InputDevice     "Mouse0" "CorePointer"
      EndSection

      Section "Files"
      EndSection

      Section "InputDevice"
          Identifier     "Mouse0"
          Driver         "mouse"
          Option         "Protocol" "auto"
          Option         "Device" "/dev/psaux"
          Option         "Emulate3Buttons" "no"
          Option         "ZAxisMapping" "4 5"
      EndSection

      Section "InputDevice"
          Identifier     "Keyboard0"
          Driver         "kbd"
      EndSection

      Section "Monitor"
          Identifier     "Monitor0"
      EndSection

      Section "Device"
          Identifier     "Device0"
          Driver         "nvidia"
          VendorName     "NVIDIA Corporation"
          BusID	   "${cfg.busIDStandalone}"
          Screen         0
      EndSection

      Section "Screen"
          Identifier     "Screen0"
          Device         "Device0"
          DefaultDepth   24
          Monitor        "Monitor0"
      EndSection
    '';
    destination = "/standalone.conf";
  };

  script = pkgs.writeTextFile {
    name = "amplifier-detect";
    text = ''
      if [ -d "${cfg.videoBusAddress}" ]; then
        ln -sf ${dockedPkg}/docked.conf /etc/X11/xorg.conf.d/amplifier.conf
      else
        ln -sf ${standalonePkg}/standalone.conf /etc/X11/xorg.conf.d/amplifier.conf
      fi
    '';
    destination = "/detect";
    executable = true;
  };
in {
  options.alienware = {
    enable = mkEnableOption "Specify if machine is an alienware machine or not";

    videoBusAddress = mkOption {
      type = types.str;
      default = "/sys/bus/pci/devices/0000:02:00.0"; #Default value from my machine
      description = "The address of the amplifier graphics card. Use lspci to find it";
    };

    busIDDocked = mkOption {
      type = types.str;
      default = "PCI:2:0:0";
      description = "This is the bus id of the external video card when docked with amplifier.";
    };

    busIDStandalone = mkOption{
      type = types.str;
      default = "PCI:1:0:0";
      description = "This is the bus id of the internal video card for when the system is not docked";
    };
  };

  config = mkIf (cfg.enable) {
    systemd.services.alienware-amplifier = {
    description = "Alienware amplifier screen profile selector";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart= "${pkgs.bash}/bin/bash ${script}/detect";
    };
  };
  };
}
