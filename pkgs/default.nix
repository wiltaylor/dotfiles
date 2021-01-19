{ pkgs, ...}:
with pkgs;
{
  g810-led = (callPackage ./os-specific/linux/g810-led/default.nix {});
  vscodium-alias = (callPackage ./applications/editors/vscode/vscodium-alias.nix {});
  masterplan = (callPackage ./applications/office/masterplan {});
  dotfiles-manpages = (callPackage ./manpages.nix {});
  i3blocks-contrib = (callPackage ./os-specific/linux/i3blocks-contrib/default.nix {});
  proton_5_21_ge_1 = (callPackage ./applications/games/GloriousEggroll/default.nix {});
}
