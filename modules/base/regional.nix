{pkgs, config, lib, ...}:
with pkgs;
with lib;
let
    cfg = config.sys;
in {
  options.sys = {
    locale = mkOption {
      type = types.str;
      description = "The locale for the machine";
      default = "en_AU.UTF-8";
    };

    timeZone = mkOption {
      type = types.str;
      description = "The timezone of the machine";
      default = "Australia/Brisbane";
    };
  };

  config = {
    i18n.defaultLocale = cfg.locale;
    time.timeZone = cfg.timeZone;
  };
}
