# __          ___ _   _______          _
# \ \        / (_) | |__   __|        | |
#  \ \  /\  / / _| |    | | __ _ _   _| | ___  _ __
#   \ \/  \/ / | | |    | |/ _` | | | | |/ _ \| '__|
#    \  /\  /  | | |    | | (_| | |_| | | (_) | |
#     \/  \/   |_|_|    |_|\__,_|\__, |_|\___/|_|
#                                 __/ |
#                                |___/
# Web: https://wil.dev
# Github: https://github.com/wiltaylor
# Contact: web@wiltaylor.dev
# Feel free to use this configuration as you wish.

# Global Environment Variables
export PATH="$HOME/go/bin:$HOME/.local/bin:/usr/local/bin:$HOME/.cargo/bin:$HOME/.emacs.d/bin:$PATH"
export XDG_CONFIG_HOME="$HOME/.config"

# Stop MS from sending Telemetry data back
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# Default Applications
export TERMINAL="alacritty"
export GOPATH=~/.go
export MOZ_USE_XINPUT2=1
export BROWSER=firefox
export EDITOR="nvim"
export READER="zathura"
export FILE="ranger"

# Move config files out of home root
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

source /usr/share/nvm/init-nvm.sh

