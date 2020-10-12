export NIX_PATH="nixos-config=$PWD/machines/$(hostname)/configuration.nix:$NIX_PATH"
echo $NIX_PATH
nixos-rebuild switch
