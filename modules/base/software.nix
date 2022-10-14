{pkgs, config, lib, ...}:
{
    # This is a list of cli tools that should be present on all of my systems.
    sys.software = with pkgs; [
        # Misc cli tools
        dutree
        hyperfine
        bottom
        wget
        curl
        bind
        killall
        bat
        file
        bintools
        tmux
        parted
        ripgrep
        socat
        unixtools.xxd
        rclone
        freshfetch
        
        # Archive Tools
        unzip
        unrar
        zip
        p7zip
        xar

        # System monitoring tools
        strace
        ltrace

        # This is in base because nix makes use of it with flakes.
        git
        git-crypt

        # Base nix tools
        nix-index
        manix

        # Ported from core - need to move out to somewhere else
        fuse-overlayfs # prob not in base
        unionfs-fuse # prob not in base
        squashfsTools # prob not in base
        squashfuse # prob not in base
        nvme-cli # hardware
        pstree # prob not in base
        ntfsprogs # hardware
        exfat # hardware
        neovim # prob not in base

        python3 # prob not in base 
    ];
}
