{pkgs, lib, config, ...}:
with lib;
let
  cfg = config.virtualization;

in {
  options.virtualization = {
    vagrant = {
      enable = mkEnableOption "Enable Vagrant";
      provider = mkOption {
        type = types.str;
        default = "libvirt";
        description = "The provider that vargrant will use.";
      };
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      (if cfg.vagrant.enable then vagrant else nil)
    ];

    environment.variables = {
      "VAGRANT_DEFAULT_PROVIDER" = mkIf (cfg.vagrant.enable) cfg.vagrant.provider;
    };

    system.activationScripts = {
      vagrant.text = mkIf (cfg.vagrant.enable) ''
        ${pkgs.vagrant}/bin/vagrant plugin install vagrant-libvirt
      '';
    };
  };
}
