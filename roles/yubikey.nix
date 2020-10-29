{config, pkgs, lib, ...}:
{
  environment.systemPackages = with pkgs; [
    gnupg
    yubikey-personalization
    yubioath-desktop
    pinentry-gtk2
  ];

  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.pcscd.enable = true;

  environment.shellInit = ''
    export GPG_TTY="$(tty)"
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
  '';

  programs = {
    ssh.startAgent = false;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "gtk2";
    };
  };
}
