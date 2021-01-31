{ pkgs }:
{
  mkShell = { name, buildInputs, script }: pkgs.mkShell {
    inherit name;
    nativeBuildInputs = buildInputs;
    shellHook = script;
  };

}
