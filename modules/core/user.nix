{pkgs, lib, config, ...}:
with builtins;
with lib;
let
  cfg = config.sys.users;

  mkUserFile = {user, filename, source}: let
    userProfile = "${config.users.users."${user}".home}";
    staticHome = "${userProfile}/.local/share/nixstatic";
  in ''
    ln -sf "${source}" "${staticHome}/${filename}"
  '';

  mkUserFileFromText = {user, filename, text}: let
    textfile = toFile filename text;
  in mkUserFile { inherit user filename; source = textfile; };

  mkCleanUp = {user, filename, homePath }: let
    userProfile = "${config.users.users."${user}".home}";
    staticHome = "${userProfile}/.local/share/nixstatic";
    updatedPath = "${userProfile}/${homePath}";
  in ''
    echo "rm ${updatedPath} -fr" >> ${staticHome}/cleanup.sh
    echo "rm ${staticHome}/${filename}" >> ${staticHome}/cleanup.sh
  '';

  mkLinker = {user, filename, homePath, group }: let
    userProfile = "${config.users.users."${user}".home}";
    staticHome = "${userProfile}/.local/share/nixstatic";
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
    staticPath = "${config.users.users."${username}".home}/.local/share/nixstatic";
    allUserFileSet = cfg.allUsers.files;
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
in {
  options.sys.users = {
    allUsers = {
      files = mkOption {
        type = types.attrs;
        default = {};
        description = "Files to add to all user profiles";
      };
    };

    primaryUser = {
      name = mkOption {
        type = types.str;
        default = "wil";
        description = "The username of the primary user on the system";
      };

      extraGroups = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Extra groups to add to primary user";
      };

      shell = mkOption {
        type = types.package;
        default = pkgs.nushell;
        description = "Sets the shell used by primary user";
      };

      files = mkOption {
        type = types.attrs;
        default = {};
        description = "Files to be added to user profile";
      };
    };

    rootUser = {
      files = mkOption {
        type = types.attrs;
        default = {};
        description = "Files to add to root user account.";
      };
    };
  };

  config = {
    users.users."${cfg.primaryUser.name}" = {
      name = cfg.primaryUser.name;
      isNormalUser = true;
      isSystemUser = false;
      extraGroups = cfg.primaryUser.extraGroups;
      uid = 1000;
      initialPassword = "P@ssw0rd01";
    };

    users.users.root = {
      name = "root";
      initialPassword = "P@ssw0rd01";
    };

    system.activationScripts = {
      primaryUserFiles.text = mkBuildScript {username = cfg.primaryUser.name; fileSet = cfg.primaryUser.files; };
      rootFiles.text = mkBuildScript {username = "root"; fileSet = cfg.rootUser.files; group = "root"; };
    };
  };
}
