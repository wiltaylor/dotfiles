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

            software = mkOption {
                type = with types; listOf package;
                default = [];
                description = "Software to install as this user";
            };

            shell = mkOption {
                type = types.enum [ "bash" "zsh" "nu"];
                default = "nu";
                description = "Type of shell to use for this user";
            };
        };

        userRoles = mkOption {
            type = with types; attrsOf (listOf anything);
            default = {};
            description = "A role is a list of functions which is run against a user if they are in said role. This allows for user specific machine settings to be split out and only run if a user has the role on a machine."; 
        };

        allUserRoles = mkOption {
            type = with types; listOf str;
            default = [];
            description = "A list of roles that are applied to all users";
        };

        users = mkOption {
            type = with types; attrsOf (submodule {
                options = {
                    files = mkOption {
                        type = types.attrs;
                        default = {};
                        description = "Files to add to the user profile.";
                    };

                    groups = mkOption {
                        type = with types; listOf str;
                        default = [];
                        description = "Extra groups to add to the user.";
                    };

                    software = mkOption {
                        type = with types; listOf package;
                        default = [];
                        description = "Software to install as this user";
                    };

                    roles = mkOption {
                        type = with types; listOf str;
                        default = [];
                        description = "Roles to apply to this user on this machine";
                    };

                    shell = mkOption {
                        type = types.enum [ "bash" "zsh" "nu"];
                        default = "nu";
                        description = "Type of shell to use for this user";
                    };

                    home = mkOption {
                        type = types.str;
                        default = "";
                        description = "Directory of the users path";
                    };

                    config = mkOption {
                        type = types.attrs;
                        default = {};
                        description = "You can put custom configuration in this section to help configure roles";
                    };

                    sshPublicKeys = mkOption {
                        type = with types; listOf str;
                        default = [];
                        description = "Public ssh key for this account";
                    };
                };
            });

            description = "Define users of the system here.";
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
        staticHome = "${userProfile}/.local/share/nix-static";
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

    getRoleFunctions = roles: foldl' (l: r: r ++ l) [] (map (r: cfg.user.userRoles."${r}") (roles ++ cfg.user.allUserRoles));
    applyRoles = {fns, user}: foldl' (u: fn: fn u) user fns;
    buildUser = user: let
        fns = getRoleFunctions user.roles;
    in 
        applyRoles { inherit fns user; };

    userScripts = mapAttrs (n: v: let
        user = buildUser v;
    in { 
        text = mkBuildScript {
            username = n;
            fileSet = user.files // cfg.user.allUsers.files;
            group = "users";
        };
    }) cfg.user.users;

    userSettings = listToAttrs( 
     map (v: {
        name = v;
        value = let
            compiledUser = buildUser cfg.user.users."${v}";
            shellpkg = if (compiledUser.shell == "nu") then 
                pkgs.nushell
            else
                (if (compildUser.shell == "zsh") then
                    pkgs.zsh
                else
                    pkgs.bash);
        in {
            name = v;
            isNormalUser = true;
            isSystemUser = false;
            extraGroups = compiledUser.groups;
            initialPassword = "P@ssw0rd01";
            packages = compiledUser.software;
            shell = shellpkg;
            openssh.authorizedKeys.keys = compiledUser.sshPublicKeys;
        };
    }) usersList) // {
        root = let
            shellpkg = if (cfg.user.root.shell == "nu") then 
                pkgs.nushell
            else
                (if (cfg.user.root.shell == "zsh") then
                    pkgs.zsh
                else
                    pkgs.bash);

        in {
            packages = cfg.user.root.software;
            shell = shellpkg;
        };
    };

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
