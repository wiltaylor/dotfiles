{ username, homedir, lib, pkgs, config, ...}:
with lib;
let
  cfg = config.userSettings;

  mkFile = { name, path, text}:
    let
      file = builtins.toFile name text;

  in {
    "$username".files."${path}/${name}".text = ''
      mkdir -p ${path}
      ln ${file} ${path}/${name} -sf
    '';
  };

in {
  options.userSettings."${username}" = {
    enable = mkEnableOption "Enable User Settings manager";

    xgd = {
      config = {
        files = mkOption {
          type = types.attrs;
          default = {};
          defaultText = "{}";
          description = "Specify files on the desktop";
        };
      };

      local = {
        files = mkOption {
          type = types.attrs;
          default = {};
          defaultText = "{}";
          description = "Specify files on the desktop";
        };
      };

      desktop = {
        enable = mkEnableOption "Enable XDG Desktop";

        path = mkOption {
          type = types.str;
          default = "${homedir}/Desktop";
          defaultText = "/home/username/Desktop";
          description = "Where to store desktop files";
        };

        files = mkOption {
          type = types.attrs;
          default = {};
          defaultText = "{}";
          description = "Specify files on the desktop";
        };
      };

      documents = {
        enable = mkEnableOption "Enable XDG Documents";

        path = mkOption {
          type = types.str;
          default = "${homedir}/Documents";
          defaultText = "/home/username/Documents";
          description = "Where to store document files";
        };

        files = mkOption {
          type = types.attrs;
          default = {};
          defaultText = "{}";
          description = "Specify files on the documents folder";
        };

      };

      download = {
        enable = mkEnableOption "Enable XDG Downloads";

        path = mkOption {
          type = types.str;
          default = "${homedir}/Downloads";
          defaultText = "/home/username/Downloads";
          description = "Where to store download files";
        };

        files = mkOption {
          type = types.attrs;
          default = {};
          defaultText = "{}";
          description = "Specify files on the downloads folder";
        };

      };

      music = {
        enable = mkEnableOption "Enable XDG Music";

        path = mkOption {
          type = types.str;
          default = "${homedir}/Music";
          defaultText = "/home/username/Music";
          description = "Where to store music files";
        };

        files = mkOption {
          type = types.attrs;
          default = {};
          defaultText = "{}";
          description = "Specify files on the Music folder";
        };

      };

      pictures = {
        enable = mkEnableOption "Enable XDG Pictures";

        path = mkOption {
          type = types.str;
          default = "${homedir}/Pictures";
          defaultText = "/home/username/Pictures";
          description = "Where to store pictures files";
        };

        files = mkOption {
          type = types.attrs;
          default = {};
          defaultText = "{}";
          description = "Specify files on the pictures folder";
        };

      };

      public = {
        enable = mkEnableOption "Enable XDG Public";

        path = mkOption {
          type = types.str;
          default = "${homedir}/Public";
          defaultText = "/home/username/Public";
          description = "Where to store public files";
        };

        files = mkOption {
          type = types.attrs;
          default = {};
          defaultText = "{}";
          description = "Specify files on the public folder";
        };

      };

      templates = {
        enable = mkEnableOption "Enable XDG Templates";

        path = mkOption {
          type = types.str;
          default = "${homedir}/Templates";
          defaultText = "/home/username/Templates";
          description = "Where to store template files folder";
        };

        files = mkOption {
          type = types.attrs;
          default = {};
          defaultText = "{}";
          description = "Specify files on the templates folder";
        };

      };

      videos = {
        enable = mkEnableOption "Enable XDG Videos";

        path = mkOption {
          type = types.str;
          default = "${homedir}/Videos";
          defaultText = "/home/username/Videos";
          description = "Where to store videos files";
        };

        files = mkOption {
          type = types.attrs;
          default = {};
          defaultText = "{}";
          description = "Specify files on the videos folder";
        };
      };
    };
};
}
