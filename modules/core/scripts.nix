{pkgs, config, lib,  ...}:
with lib;
with builtins;

let
  runtimeShell = pkgs.runtimeShell;
  cfg = config.sys;
in {
  options.sys.script = mkOption {
    type = types.attrs;
    description = "Scripts to create and add to the system";
    default = {};
  };
  config = let
    
    scriptNames = builtins.attrNames cfg.script;

      mkScriptTool = name: let
        scriptTxt = mkScriptString cfg.script."${name}";
        in pkgs.writeScriptBin name scriptTxt;

      scriptPackages = map (s: mkScriptTool s) scriptNames;

      mkScriptString = scriptOpts: let
        mkOption = name: ''
        "${name}")
            ${name}handler "$@"
        ;;
        '';
            
        mkAction = name: body: ''
        ${name}handler() {
        ${body}
        }
        '';

        mkUsage = name: msg: ''
        echo "${name} - ${msg}"
        '';

        mkLongUsage = name: msg: ''
        ${name}usage() {
        echo "$progname ${name}"
        echo ""
        echo "${msg}"
        }
        '';

        mkLongHelpSelect = name: ''
        "${name}")
            ${name}usage
        ;;
        '';

        actions = concatStrings (map (opt: (mkAction opt.name opt.action)) scriptOpts);
        selects = concatStrings (map (opt: (mkOption opt.name)) scriptOpts);
        usage = concatStrings (map (opt: (mkUsage opt.name opt.shortHelp)) scriptOpts);
        longusage = concatStrings (map (opt: (mkLongUsage opt.name opt.longHelp)) scriptOpts);
        usageselect = concatStrings(map (opt: (mkLongHelpSelect opt.name)) scriptOpts);
      in ''
        #!${runtimeShell}
        
        ## Action Functions
        ${actions}

        ## Usage Functions
        ${longusage}

        helpcommand() {
          case $1 in 
          ${usageselect}
          *)
            echo "Unknown Command"
          ;;
          esac
           
        }

        cmd=$1
        progname="$(basename $0)"
        shift 1
        case $cmd in
        ${selects}
        "help")
            helpcommand $1
        ;;
        *)
        echo "Usage:"
        echo "$progname <command> [options]"
        echo "help <command> - Get more help on specific sub command"
        ${usage}

        ;;
        esac
      '';
in {
    sys.software = scriptPackages;
  };
}
