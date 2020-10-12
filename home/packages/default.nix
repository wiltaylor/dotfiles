[
  (self: super: with super; {

    my = {
      vscodium-alias = (callPackage ./vscodium-alias.nix {});
    };

    nur = import (builtins.fetchTarbakk "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit super;
    };

    unstable = import <nixos-unstable> { inherit config; };

  })
]
