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


let 
  sources = import ./nix/sources.nix;

  nixpkgs = sources."nixpkgs-unstable";

  pkgs = import nixpkgs{};

  in pkgs.mkShell rec {
    name = "home-manager-shell";

    buildInputs = with pkgs; [
      niv
      (import sources.home-manager {inherit pkgs;}).home-manager
    ];

    shellHook = ''
export NIX_PATH="nixpkgs=${nixpkgs}:home-manager=${sources."home-manager"}"
export HOME_MANAGER_CONFIG="./home.nix";
    '';
  }
