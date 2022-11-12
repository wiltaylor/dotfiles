{pkgs}:
with builtins;
{
    debugPrint = obj: trace (toJSON obj) obj;

    mkNuScriptBin = name: text: 
        pkgs.writeTextFile {
          name = name;
          text = ''
            #!${pkgs.nushell}/bin/nu
            ${text}
          '';
          executable = true;
          destination = "/bin/${name}";
        };

    mergeUser = user: config: 
    {

        files = if (hasAttr "files" config) then
            (user.files // config.files)
        else
            user.files;

        groups = if (hasAttr "groups" config) then
            (user.groups ++ config.groups)
        else
            user.groups;

        software = if (hasAttr "software" config) then
            (user.software ++ config.software)
        else
            user.software;

        roles = user.roles;

        shell = user.shell;

        home = user.home;

        config = user.config;

        sshPublicKeys = user.sshPublicKeys;
    };
}
