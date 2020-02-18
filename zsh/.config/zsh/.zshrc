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

export ZSH="$XDG_CONFIG_HOME/zsh/oh-my-zsh"
ZSH_THEME="awesomepanda"
plugins=(git archlinux cargo gpg-agent)

source $ZSH/oh-my-zsh.sh
export LANG=en_AU.UTF-8

alias vim="nvim"

gpg-connect-agent updatestartuptty /bye > /dev/null

alias reset-gpg="gpg-connect-agent updatestartuptty /bye > /dev/null"
