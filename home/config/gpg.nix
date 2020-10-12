{ pkgs, lib, config, ... }:
{
  home.packages = with pkgs; [
    pinentry-gtk2
  ];


#  services.gpg-agent = {
#    enable = true;
#    enableSshSupport = true;
#    sshKeys = [ "8E2F0F7FC027E5EC914378BBD596B7D4B930ACA1" ];
#    pinentryFlavor = "gtk2";
#    enableScDaemon = true;
#  };

  home.file = {
    ".ssh/authorized_keys".source = ../files/gpg/authorized_keys;
   ".gnupg/gpg-agent.conf".source = ../files/gpg/gpg-agent.conf;
   ".gnupg/gpg.conf".source = ../files/gpg/gpg.conf;
   ".gnupg/public.key".source = ../files/gpg/public.key;
  };
 }
