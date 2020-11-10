{
  description = "Wil Taylor's system configuration";

  inputs = {
    nixos.url = "nixpkgs/nixos-20.09";
    nixos-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-20.09";
    home-manager.inputs.nixpkgs.follows = "nixos";
    wtdevtools.url = "github:wiltaylor/wtdevtools";
  };

  outputs = inputs @ {self, nixos, nixos-unstable, home-manager, wtdevtools, ... }:
  let 
    system = "x86_64-linux";

  in {

    overlay = final: prev: {
      devtool = wtdevtools.defaultPackage.${system};
    };

    #legacyPackages."${system}"."devtools" = wtdevtools."${system}";
    
    nixosConfigurations.titan = nixos.lib.nixosSystem {
      inherit system;

      specialArgs = {
       dts = wtdevtools;
      };

      
      modules = [
        home-manager.nixosModules.home-manager
        (import ./hosts/titan.nix)

      ];
    };


  };
}
