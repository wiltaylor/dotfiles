{pkgs, lib, config, ...}:
with lib;
with pkgs;
let
  cfg = config.sys.virtualisation;
  cpuType = config.sys.cpu.type;

in {
  options.sys.virtualisation = {
    kvm = {
      enable = mkEnableOption "Enable KVM";
    };

    docker = {
      enable = mkEnableOption "Enable Docker";
    };

    flatpak = {
      enable = mkEnableOption "Enable flatpack";
    };
  };

  config = {
    virtualisation.libvirtd.enable = cfg.kvm.enable;
    virtualisation.docker.enable = cfg.docker.enable;

    boot.kernelModules = [
      (mkIf (cpuType == "amd") "kvm-amd")
      (mkIf (cpuType == "intel") "intel-amd")
    ];

    environment.systemPackages = with pkgs; [
        (mkIf (cfg.kvm.enable) quickemu)
    ];

    services.flatpak.enable = cfg.flatpak.enable;
    xdg.portal.enable = mkIf cfg.flatpak.enable true;
  };
}
