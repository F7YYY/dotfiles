#!/usr/bin/env bash
#
# GTKLOCK + CORRUPTOR
#####################

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
    local required_tools=("notify-send" "grimshot" "corrupter" "gtklock")
    local missing_tools=()

    for tool in "${required_tools[@]}"; do
        if ! command -v "$tool" &>/dev/null; then
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

# Main function to handle emoji parameters
main() {
    if requirements; then
        local tmpbg="/tmp/x.png"
        grimshot save screen /tmp/x.png
        corrupter "$tmpbg" "$tmpbg"
        gtklock -SHi -T 10 -b $tmpbg;
        rm "$tmpbg"
    fi
}

# Start of the script
main
