{pkgs, config, lib, ...}:
with lib;
with builtins;
{
  options.sys.audio = {
    server = mkOption {
      type = types.enum [ "pulse" "pipewire" "none" ];
      default = "none";
      description = "Audio server to use";
    };
  };

  imports = [ ./pulse.nix ./pipewire.nix ];
}
