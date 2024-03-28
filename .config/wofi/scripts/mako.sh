#!/usr/bin/env bash
#
# WOFI MAKO-MENU
################
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
    local required_tools=("notify-send" "wofi" "makoctl")
    local missing_tools=()

    for tool in "${required_tools[@]}"; do
        if [ ! command -v "$tool" &>/dev/null ]; then
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

# Notify function to handle makoctl logic
notify() {
    local selected="$1"

    case "$selected" in
        "Yes")
            makoctl set-mode default
        ;;
        "No")
            makoctl set-mode do-not-disturb
        ;;
        "Dismiss")
            makoctl dismiss -a
        ;;
        *)
            cleanup
        ;;
    esac
}

# Main function to display the mako menu and handle user input
main() {
    local lfg=false

    local menu=("Yes"
    			"No"
    			"Dismiss"
    			"<----DONE---->")

    if requirements; then
        lfg=true
    fi

    while $lfg; do
        local selected=$(printf "%s\n" "${menu[@]}" | wofi --dmenu --prompt "<NOTIFICATIONS>" | tr -d '\n')

        if [[ -z "$selected" ]]; then
            # Allow the escape key to return to the prior menu if in a submenu
            if [[ "${#menu[@]}" -gt 8 ]]; then
                continue
            else
                break
            fi
        fi

        notify "$selected"
    done
}

# Start of Script
main
