{ pkgs, config, lib, ...}:
pkgs.writeScriptBin "firefox-secure" ''
  #!/run/current-system/sw/bin/bash

  ${pkgs.bubblewrap}/bin/bwrap --ro-bind /nix /nix \
  --ro-bind /run/current-system /run/current-system \
  --ro-bind /etc/fonts /etc/fonts \
  --ro-bind /etc/machine-id /etc/machine-id \
  --ro-bind /etc/resolv.conf /etc/resolv.conf \
  --dir /run/user/"$(id -u)" \
  --ro-bind /run/user/"$(id -u)"/pulse /run/user/"$(id -u)"/pulse \
  --dev /dev \
  --dev-bind /dev/dri /dev/dri \
  --ro-bind /sys/dev/char /sys/dev/char \
  --ro-bind /sys/devices/pci0000:00 /sys/devices/pci0000:00 \
  --proc /proc \
  --tmpfs /tmp \
  --tmpfs $HOME \
  --ro-bind $HOME/.Xauthority $HOME/.Xauthority \
  --ro-bind $HOME/Desktop $HOME/Desktop \
  --ro-bind /tmp/.X11-unix/X0 /tmp/.X11-unix/X0 \
  --bind /home/$USER/.mozilla /home/$USER/.mozilla \
  --bind /home/$USER/Downloads /home/$USER/Downloads \
  --unshare-all \
  --share-net \
  --hostname RESTRICTED \
  --setenv HOME $HOME \
  --setenv GTK_THEME Adwaita:dark \
  --setenv PATH /run/current-system/sw/bin \
  --die-with-parent \
  ${pkgs.firefox}/bin/firefox
''
