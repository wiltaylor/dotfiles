{pkgs, lib, config, ...}:
with lib;
let
  cfg = config.sys.virtualisation;
  cpuType = config.sys.cpu.type;

in {
  options.sys.virtualisation = {
    vagrant = {
      enable = mkEnableOption "Enable Vagrant";
      provider = mkOption {
        type = types.str;
        default = "libvirt";
        description = "The provider that vargrant will use.";
      };
    };

    kvm = {
      enable = mkEnableOption "Enable KVM";
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      (if cfg.vagrant.enable then vagrant else nil)
    ];

    virtualisation.libvirtd.enable = cfg.kvm.enable;

    boot.kernelModules = [
      (mkIf (cpuType == "amd") "kvm-amd")
      (mkIf (cpuType == "intel") "intel-amd")
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
