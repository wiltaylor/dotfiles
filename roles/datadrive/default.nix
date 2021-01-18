{ pkgs, config, lib, ...}:
{
  boot.initrd.luks.devices."datacrypt".device = "/dev/disk/by-label/DATACRYPT";

  fileSystems."/data" = {
    device = "/dev/disk/by-label/DATADISK";
    fsType = "btrfs";
    options = [ "subvol=@" ];
  };
}
