{ pkgs, config, lib, ...}:
{
  environment.systemPackages = with pkgs; [
    microcodeAmd
  ];
}
