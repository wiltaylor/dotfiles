{
  description = "Wil Taylor's system configuration";

  inputs = {
    nixos.url = "nixpkgs/nixos-20.09";
    nixos-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-20.09";
    home-manager.inputs.nixpkgs.follows = "nixos";


  };

  outputs = inputs @ {self, nixos, nixos-unstable, home-manager, ... }:
  let 
    system = "x86_64-linux";
  in {

    nixosConfigurations.titan = nixos.lib.nixosSystem {
      inherit system;
      modules = [
        home-manager.nixosModules.home-manager
        (import ./hosts/titan.nix)
      ];
    };


  };
}
