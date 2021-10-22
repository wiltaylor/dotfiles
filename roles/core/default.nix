{config, pkgs, lib, ...}:
{
  environment.systemPackages = with pkgs; [

    imagemagick # move out to shells

    lm_sensors # Move to amd and intel

    kubectl # Should be moved to shell
    kubernetes-helm # Shell
    kind # above shell
    doctl # devops shell

    nmap # Security shell

    neovimWT
    clinfo # Move to opencl when set back up
    freerdp
  ];
}
