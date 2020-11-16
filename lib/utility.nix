{ system, ... }:
{
  pkgImport = pkgs:
    import pkgs {
      inherit system;
      config = { allowUnfree = true; };
    };

  mkOverlay = pkgs:
    final: prev: {
      inherit pkgs;
    };
}
