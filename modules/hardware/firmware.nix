{pkgs, config, lib, ...}:
with pkgs;
with lib;
let
  cfg = config.sys;
in {
    config = {
        # Enable all unfree hardware support.
        hardware.firmware = with pkgs; [ firmwareLinuxNonfree ];
        hardware.enableAllFirmware = true;
        hardware.enableRedistributableFirmware = true;
    };
}
