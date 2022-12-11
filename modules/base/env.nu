# Nushell Environment Config File

def create_left_prompt [] {
    let path_segment = if (is-admin) {
        $"(ansi red_bold)($env.PWD)"
    } else {
        $"(ansi green_bold)($env.PWD)"
    }

    $path_segment
}

def create_right_prompt [] {
    let time_segment = ([
        (date now | date format '%d/%m/%Y %r')
    ] | str collect)

    $time_segment
}

# Setup git
let-env GPG-TTY = (^tty)
let-env SSH_AUTH_SOCK = "/run/user/1000/gnupg/S.gpg-agent.ssh"

# Use nushell functions to define your right and left prompt
let-env PROMPT_COMMAND = { create_left_prompt }
let-env PROMPT_COMMAND_RIGHT = { create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
let-env PROMPT_INDICATOR = { "〉" }
let-env PROMPT_INDICATOR_VI_INSERT = { ": " }
let-env PROMPT_INDICATOR_VI_NORMAL = { "〉" }
let-env PROMPT_MULTILINE_INDICATOR = { "::: " }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
let-env ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) | path expand -n }
    to_string: { |v| $v | path expand -n | str collect (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) | path expand -n }
    to_string: { |v| $v | path expand -n | str collect (char esep) }
  }
}

# Directories to search for scripts when calling source or use
#
# By default, <nushell-config-dir>/scripts is added
let-env NU_LIB_DIRS = [
    ($nu.config-path | path dirname | path join 'scripts')
]

# Directories to search for plugin binaries when calling register
#
# By default, <nushell-config-dir>/plugins is added
let-env NU_PLUGIN_DIRS = [
    ($nu.config-path | path dirname | path join 'plugins')
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# let-env PATH = ($env.PATH | split row (char esep) | prepend '/some/path')
#
def "net wifi scan" [] {
    ^nmcli -m tabular -c no -e yes -f BSSID,SSID,CHAN,RATE,SIGNAL,SECURITY dev wifi | from ssv
}

def "net wifi list" [] {
    ^nmcli -m tabular -c no -e yes c | from ssv
}

def "net wifi add" [ssid: string ,password?: string] {
    if $password == null {
        ^nmcli dev wifi connect $ssid 
    } else {
        ^nmcli dev wifi connect $ssid password $password
    }
}

def "net devices list" [] {
    ^nmcli -m tabular -c no -e yes dev | from ssv
}

def "net route list" [] {
    ^ip -j route | from json
}

def "net connectivity" [] {
    let check = (^nmcli n connectivity check | str trim)

    $check == "full"
}

def "nx pkg" [] {
    cd ~/.dotfiles
    ^nix search ".#" | parse "* {name} ({version})\n"
}

def "nx update" [] {
    cd ~/.dotfiles
    nix flake update
}

def "nx apply" [] {
    cd ~/.dotfiles
    ^sudo nixos-rebuild switch --flake ".#"
}

def "nx options list" [query:string] {
    ^manix $query | split row "\n\n\n" | parse --regex "#(?<Option>.+)\n(?<Description>.+)\ntype: (?<Type>.+)"
}

def "sys usb" [] {
    ^lsusb | lines | parse "Bus {busId} Device {deviceId}: ID {id} {name}"
}

def "sys pci" [] {
    ^lspci -v -mm | parse --regex "Slot:(?<slot>.+)\nClass:(?<class>.+)\nVendor:(?<vendor>.+)\n(?<device>.+)\nSVendor:(?<svendor>.+)\nSDevice:(?<sdevice>.+)\nRev:(?<rev>.+)\nProgIf:(?<progif>.+)"
}

def "sys disk" [] {
    ^lsblk -l --json | from json | get blockdevices | flatten
}
