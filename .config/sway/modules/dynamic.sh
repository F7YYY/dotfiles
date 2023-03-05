#!/sbin/bash
#
# RECURSIVELY CHANGES NON-HIDDEN WALLPAPERS
while :; do
    killall -e swaybg
    killall -e $(pgrep -f ${BASH_SOURCE[0]} | grep -v $$)
    swaybg -i $(find ~/Pictures/Wallpapers/* | shuf -n1) -m stretch &
    sleep 22
done
