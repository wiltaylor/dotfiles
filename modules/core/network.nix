{pkgs, config, lib, ...}:
with lib;
with builtins;
let
  cfg = config.sys.networking;
  wifiSecrets = tryeval (config.sys.secruity.secrets.wifi);
  wifiNetworks = if wifiSecrets.success then wifiSecrets.value else {};


in {
  options.sys.networking = {
    wifi = mkEnableOption "Enable wifi";
  };

  config = {
    networking.networkmanager.enable = true;
    networking.wireless.enable = cfg.wifi;
    networking.wireless.allowAuxiliaryImperativeNetworks = cfg.wifi;
    # networking.wireless.networks = wifiNetworks; #TODO: add networks to wifi via activation script.

  };
}
