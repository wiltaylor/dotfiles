[
  (self: super: with super; {
    g810-led = (callPackage ./os-specific/linux/g810-led/default.nix {});
    vscodium-alias = (callPackage ./applications/editors/vscode/vscodium-alias.nix {});
    masterplan = (callPackage ./applications/office/masterplan {});
  })
]
