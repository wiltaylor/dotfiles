{pkgs, config, lib, ...}:
with pkgs;
with lib;
with builtins;
let 
    cfg = config.sys;
in {
    options.sys.user = {
        allUsers = {
            files = mkOption {
                type = types.attrs;
                default = {};
                description = "Files to add to all user profiles";
            };
        };

        root = {
            files = mkOption {
                type = types.attrs;
                default = {};
                description = "Files to add to root user profile";
            };
        };

        users = mkOption {
            type = types.attrs;
            default = {};
            description = "Extra users to add to the system";
        };
    };

    config = let
      mkUserFile = {user, filename, source}: let
        userProfile = "${config.users.users."${user}".home}";
        staticHome = "${userProfile}/.local/share/nix-static";
      in ''
        ln -sf "${source}" "${staticHome}/${filename}"
      '';

      mkUserFileFromText = {user, filename, text}: let
        textfile = toFile filename text;
      in mkUserFile { inherit user filename; source = textfile; };

      mkCleanUp = {user, filename, homePath }: let
        userProfile = "${config.users.users."${user}".home}";
        staticHome = "${userProfile}/.local/share/nix-static";
        updatedPath = "${userProfile}/${homePath}";
      in ''
        echo "rm ${updatedPath} -fr" >> ${staticHome}/cleanup.sh
        echo "rm ${staticHome}/${filename}" >> ${staticHome}/cleanup.sh
      '';

      mkLinker = {user, filename, homePath, group }: let
        userProfile = "${config.users.users."${user}".home}";
        staticHome = "${userProfile}/.local/share/nixi-static";
        targetPath = "${userProfile}/${homePath}";
        targetFolder = dirOf targetPath;
      in ''
        mkdir -p "${targetFolder}"
        ln -sf "${staticHome}/${filename}" "${targetPath}"
        chown -h ${user}:${group} ${targetPath} 
      '';

      buildFileScript = {username, fileSet}: concatStringsSep "\n" 
        (map (name: (if (hasAttr "source" fileSet."${name}")
        then mkUserFile {user = username; filename = name; source = fileSet."${name}".source;}
        else mkUserFileFromText { user = username; filename = name; text = fileSet."${name}".text;}
        )) (attrNames fileSet));

      buildCleanUp = {username, fileSet}: concatStringsSep "\n"
        (map (name: mkCleanUp { user = username; homePath = fileSet."${name}".path; filename = name;}) (attrNames fileSet));

      buildLinker = {username, fileSet, group}: concatStringsSep "\n"
        (map (name: mkLinker { user = username; homePath = fileSet."${name}".path; filename = name; inherit group; }) (attrNames fileSet));

      mkBuildScript = {username, fileSet, group ? "users"}: let 
        staticPath = "${config.users.users."${username}".home}/.local/share/nix-static";
        allUserFileSet = cfg.user.allUsers.files;
      in ''
          echo "Setting up user files for ${username}"
          if [ -f "${staticPath}/cleanup.sh" ]; then
            ${staticPath}/cleanup.sh
            rm ${staticPath}/cleanup.sh
          fi

          echo "Linking user files"
          mkdir -p ${staticPath}
          ${buildFileScript { inherit username fileSet; }}
          ${buildFileScript { inherit username; fileSet = allUserFileSet; }}

          ${buildCleanUp { inherit username fileSet; }}
          ${buildCleanUp { inherit username; fileSet = allUserFileSet; }}

          if [ -f "${staticPath}/cleanup.sh" ]; then
            chmod +x ${staticPath}/cleanup.sh
          fi

          ${buildLinker { inherit username group; fileSet = allUserFileSet; }}
          ${buildLinker { inherit username fileSet group; }}
        '';
    usersList = attrNames cfg.user.users;

    userScripts = mapAttrs (n: v: { text = mkBuildScript {
        username = n;
        fileSet = v.files // cfg.user.allUsers.files;
        group = "users";
    };}) cfg.user.users;

    userSettings = listToAttrs( 
     map (v: {
        name = v;
        value = {
            name = v;
            isNormalUser = true;
            isSystemUser = false;
            extraGroups = if (hasAttr "groups" cfg.user.users."${v}") then cfg.user.users."${v}".groups else [];
            initialPassword = "P@ssw0rd01";
        };
    }) usersList);

    in {
        system.activationScripts = {
            user-rootFile.text = mkBuildScript { 
                username = "root"; 
                fileSet = cfg.user.root.files // cfg.user.allUsers.files; 
                group = "root"; 
            };
        } // userScripts;

        users.users = userSettings;
    };
}
