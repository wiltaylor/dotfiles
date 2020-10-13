# __          ___ _   _______          _
# \ \        / (_) | |__   __|        | |
#  \ \  /\  / / _| |    | | __ _ _   _| | ___  _ __
#   \ \/  \/ / | | |    | |/ _` | | | | |/ _ \| '__|
#    \  /\  /  | | |    | | (_| | |_| | | (_) | |
#     \/  \/   |_|_|    |_|\__,_|\__, |_|\___/|_|
#                                 __/ |
#                                |___/
# Web: https://wil.dev
# Github: https://github.com/wiltaylor
# Contact: web@wiltaylor.dev
# Feel free to use this configuration as you wish.

{pkgs, ... }:
{
  config = {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = import ./pkgs;


  };

  imports = [
    ./g810-led.nix
    ./users.nix
    ./nixos.nix
    ./wifi.nix
    ./net.nix
    ./yubikey.nix
    ./sshd.nix
    ./desktop.nix
  ];
}
