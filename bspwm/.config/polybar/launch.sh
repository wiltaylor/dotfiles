#!/usr/bin/env bash

#terminate already running bar instances
killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

#Launch bar1 
MONITOR=DP-0 polybar bar1 &
MONITOR=DP-2 polybar bar1 &
MONITOR=DP-4 polybar bar1 &
echo "Bars launched"
