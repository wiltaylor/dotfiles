{pkgs, config, lib, ...}:
{

  programs.git = {
    enable = true;
    userName = "Wil Taylor";
    userEmail = "cert@wiltaylor.dev";
    signing = {
      key = "0xEC571018542D2ACC";
      signByDefault = false;
    };
  };
}
