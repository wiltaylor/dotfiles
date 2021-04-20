{ pkgs, ...}: 
{
  environment.systemPackages = with pkgs; [
    libmtp
    gvfs
  ];
}
