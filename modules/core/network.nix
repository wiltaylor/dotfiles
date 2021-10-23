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
    networking.wireless.enable = cfg.wifi;
    networking.wireless.allowAuxiliaryImperativeNetworks = cfg.wifi;
    networking.wireless.networks = wifiNetworks;

    networking.networkmanager.unmanaged = mkIf cfg.wifi [
      "*" "except:type:wwan" "except:type:gsm"
    ];
  };
}
