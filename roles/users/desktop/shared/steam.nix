{pkgs, lib, ...}:
{
  home.activation.steam-proton = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir ~/.steam/root/compatibilitytools.d -p
    rm ~/.steam/root/compatibilitytools.d/Proton_5.21-GE-1 -fr
    ln -fs  ${pkgs.my.proton_5_21_ge_1}/proton ~/.steam/root/compatibilitytools.d/Proton_5.21-GE-1

  '';
}
