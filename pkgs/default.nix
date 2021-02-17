{ pkgs, ...}:
with pkgs;
{
  g810-led = (callPackage ./os-specific/linux/g810-led/default.nix {});
  vscodium-alias = (callPackage ./applications/editors/vscode/vscodium-alias.nix {});
  masterplan = (callPackage ./applications/office/masterplan {});
  dotfiles-manpages = (callPackage ./manpages.nix {});
  i3blocks-contrib = (callPackage ./os-specific/linux/i3blocks-contrib/default.nix {});
  proton_5_21_ge_1 = (callPackage ./applications/games/GloriousEggroll/default.nix {});
  proton_6_1_ge_2 = (callPackage ./applications/games/GloriousEggroll/proton-6.1-GE-2.nix {});
  proton_6_1_ge_1 = (callPackage ./applications/games/GloriousEggroll/proton-6.1-GE-1.nix {});
  pm-bridge = (callPackage ./override/protonmail-bridge/default.nix {});
  firefox-secure = (callPackage ./applications/browsers/firefox/default.nix {});
  hwdata = (callPackage ./os-specific/linux/hwdata/default.nix {});
  pciutils = (callPackage ./os-specific/linux/pciutils/default.nix {});
}
