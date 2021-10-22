{pkgs, config, lib, ...}:
with lib;
let 
  cfg = config.sys;
in {
  options.sys = {
    locale = mkOption {
      type = types.str;
      description = "The locale for the machine";
    };

    timeZone = mkOption {
      type = types.str;
      description = "The timezone of the machine";
    };
  };

  config = {
    i18n.defaultLocale = cfg.locale;
    time.timeZone = cfg.timeZone;
  };
}
