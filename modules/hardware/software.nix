{pkgs, config, lib, ...}:
{
    sys.software = with pkgs; [
        dmidecode
        acpi
        hwdata
        pciutils
        usbutils
        btrfs-progs
        smartmontools
        iotop
        nvme-cli
        ntfsprogs
        exfat
        lm_sensors
        rtw88-firmware
    ];

}
