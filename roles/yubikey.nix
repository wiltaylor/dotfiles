{config, pkgs, lib, ...}:
{
  environment.systemPackages = with pkgs; [
    gnupg
    yubikey-personalization
    yubioath-desktop
  ];

  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.pcscd.enable = true;
}
