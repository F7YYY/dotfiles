#!/usr/bin/env sh
#
# WOFI POWER-MENU #
###################

# Exit on error, unset variable as error, and propagate failure in pipelines
set -euo pipefail

# Trap & cleanup previous executions
cleanup() {
    # Kill all remaining processes still running
    killall -9Ieqg $$ >/dev/null 2>&1
    exit 0
}
trap cleanup EXIT

# Function to handle power menu options
powermenu() {
    local selected="$1"

    case "$selected" in
        "Reload")
            if [[ $XDG_SESSION_DESKTOP =~ ^sway* ]]; then
                swaymsg reload
            elif [ $XDG_SESSION_DESKTOP == "hyprland" ]; then
                hyprctl reload
            else
                systemctl --user daemon-reload
                systemctl --user daemon-reexec
            fi
            ;;
        "Lock")
            "$lock"
            ;;
        "Suspend")
            systemctl suspend && "$lock"
            ;;
        "Logout")
            if [[ $XDG_SESSION_DESKTOP =~ ^sway* ]]; then
                swaymsg exit
            elif [ $XDG_SESSION_DESKTOP == "hyprland" ]; then
                hyprctl dispatch exit
            else
                loginctl terminate-session "$XDG_SESSION_ID"
                loginctl kill-user $(whoami)
            fi
            ;;
        "Reboot")
            systemctl reboot
            ;;
        "Reboot>BIOS")
            systemctl reboot --firmware-setup
            ;;
        "Shutdown")
            systemctl poweroff
            ;;
        *)
            cleanup
            ;;
    esac
}

# Main function to display the power menu
main() {
    local lock=$HOME/.config/wofi/scripts/lock.sh
    local menu=("Reload"
    			"Lock"
    			"Suspend"
    			"Logout"
    			"Reboot"
    			"Reboot>BIOS"
    			"Shutdown"
    			"<----DONE---->")
    local selected=$(printf "%s\n" "${menu[@]}" | wofi --dmenu --prompt "<Power-Menu>" | tr -d '\n')

    powermenu "$selected"
}

# Start of the script
main
