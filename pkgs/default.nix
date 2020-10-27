[
  (self: super: with super; {
    g810-led = (callPackage ./os-specific/linux/g810-led/default.nix {});
  })
]
