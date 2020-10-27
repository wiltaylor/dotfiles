{pkgs, config, lib, ...}:
{
  home.file = {
    ".ssh/authorized_keys".source = ./authorized_keys;
    ".gnupg/gpg_agent.conf".source = ./gpg-agent.conf;
    ".gnupg/gpg.conf".source = ./gpg.conf;
    ".gnupg/public.key".source = ./public.key;
  };
}
