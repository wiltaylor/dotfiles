{...}:
{
  imports = [ 
    (import "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos")
    ./wil.nix
  ];
}
