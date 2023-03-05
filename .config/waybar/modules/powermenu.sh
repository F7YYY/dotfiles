#!/bin/env bash

entries="⇠ Logout\n⏾ Suspend\n⭮ Reboot\n⏻ Shutdown"
selected=$(echo -e $entries|wofi --width 250 --height 210 --dmenu --cache-file /dev/null | awk '{print tolower($2)}')

case $selected in
    logout)
        swaymsg exit;;
    suspend)
        exec systemctl suspend;;
    reboot)
        exec systemctl reboot;;
    shutdown)
        exec systemctl poweroff -i;;
esac
