{pkgs, config, lib, ...}:
{
  # Stops sudo from timing out.
  security.sudo.extraConfig = "Defaults env_reset,timestamp_timeout=-1";
  security.sudo.execWheelOnly = true;
}
