{config, pkgs, lib, ...}:
{
  users.users.wil = {
    name = "wil";
    description = "Wil Taylor";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "libvirtd" "docker" ];
    uid = 1000;
    initialPassword = "P@ssw0rd01";
    shell = pkgs.zsh;
  };

  home-manager.users.wil = {
    
    imports = [
#      ./roles/gpg
      ./roles/neovim
      ./roles/git
      ./roles/desktop/i3wm
      ./roles/ranger
      ./roles/tmux
      ./roles/zsh
    ];

    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = import ../pkgs;

    systemd.user.startServices = true;
    home.stateVersion = "20.09";
    home.username = "wil";
    home.homeDirectory = "/home/wil";

  };
}
