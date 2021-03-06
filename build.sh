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

# Old command that basically works the same way.
#nixos-rebuild switch --flake '.#'  

# this is what nixos-rebuild basically does.
# Simplifying build so i can start pulling it apart and creating my 
# own boot loader and init setup.
rm ./result -fr
nix build .#nixosConfiguration.$(hostname)
#./result/bin/switch-to-configuration

