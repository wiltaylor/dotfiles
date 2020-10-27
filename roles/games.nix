{pkgs, lib, config, ...}:
{
  hardware.opengl = {
    driSupport32Bit = true;
    extraPackages32 = with pkgs.pkgsi686Linux; [
      libva
    ];
  };

  hardware.pulseaudio.support32Bit = true;
  hardware.steam-hardware.enable = true;

  environment.systemPackages = with pkgs; [
    steam
  ];
}
