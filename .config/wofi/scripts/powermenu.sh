#!/usr/bin/env bash
#
# WOFI POWER-MENU #
###################
#
# Exit on error, unset variable as error, and propagate failure in pipelines
set -euo pipefail

# Trap & cleanup previous executions
cleanup() {
    # Kill all remaining processes still running
    killall -9Ieqg $$ >/dev/null 2>&1
    exit 0
}
trap cleanup EXIT

# Function to check if the required tools are installed
requirements() {
    local required_tools=("wofi" "systemctl" "swaymsg" "hyprctl")
    local missing_tools=()

    for tool in "${required_tools[@]}"; do
        if ! [ command -v "$tool" &>/dev/null ] || [ command -v "$tool" &>/dev/null ]; then
            missing_tools+=("$tool")
        fi
    done

    if [ ${#missing_tools[@]} -gt 0 ]; then
        notify-send -u critical -a "$0" "Missing tools: ${missing_tools[@]}" ||
        echo "Missing tools: ${missing_tools[@]}" 2>&1
        return 1
    else
        return 0
    fi
}

# Function to handle power menu options
powermenu() {
    local selected="$1"
    local uprocesses=(killall -u username)

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
            if [[ $XDG_SESSION_DESKTOP =~ ^sway* ]]; then
                $swaylock
            elif [ $XDG_SESSION_DESKTOP == "hyprland" ]; then
                $hyprlock
            else
                loginctl lock-session
            fi
        ;;
        "Suspend")
            systemctl suspend && "$LOCK"
        ;;
        "Logout")
            if [[ $XDG_SESSION_DESKTOP =~ ^sway* ]]; then
                swaymsg exit && $uprocesses
            elif [ $XDG_SESSION_DESKTOP == "hyprland" ]; then
                hyprctl dispatch exit && $uprocesses
            else
                loginctl terminate-session "$XDG_SESSION_ID"
                loginctl kill-user $(whoami)
                $uprocesses
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
        ""|*)
            cleanup
        ;;
    esac
}

# Main function to display the power menu
main() {
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
