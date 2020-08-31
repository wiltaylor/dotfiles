#!/usr/bin/env bash
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
#terminate already running bar instances

killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

#Launch bar1
case $HOSTNAME in
	titan)
	MONITOR=DP-0 polybar bar1 &
	MONITOR=DP-2 polybar bar1 &
	MONITOR=DP-4 polybar bar1 &
	;;
	mini)
	xrandr --output DP1-1 --right-of eDP1 --output DP1-2 --left-of eDP1
	sleep 1s
	MONITOR=eDP1 polybar bar1-mini &
	MONITOR=DP1-1 polybar bar1-mini &
	MONITOR=DP1-2 polybar bar1-mini &
	;;	
esac
echo "Bars launched"
