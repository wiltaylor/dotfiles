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

    docker = {
      enable = mkEnableOption "Enable Docker";
    };

    flatpak = {
      enable = mkEnableOption "Enable flatpack";
    };

    appImage = {
      enable = mkEnableOption "Enable app image";
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      (if cfg.vagrant.enable then vagrant else nil)
      (if cfg.appImage.enable then appimage-run else nil)
    ];

    virtualisation.libvirtd.enable = cfg.kvm.enable;
    virtualisation.docker.enable = cfg.docker.enable;

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

    services.flatpak.enable = cfg.flatpak.enable;
    xdg.portal.enable = mkIf cfg.flatpak.enable true;
  };
}
