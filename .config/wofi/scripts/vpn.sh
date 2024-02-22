#!/usr/bin/env bash
#
# OpenVPN & WireGuard abstraction layer for waybar and wofi
###########################################################
# Usage: ./wireguard.sh [menu|toggle NAME]
# - When executed without any arguments, it prints the current WireGuard connections.
# - When executed with "menu" as the argument, it prints all available WireGuard connections in a format compatible with Wofi.
# - When executed with "toggle NAME" as the argument, it toggles the status of the specified WireGuard connection.
##############################################################################################################################

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
    local required_tools=("notify-send" "wofi" "waybar" "nmcli" "speedtest" "wg" "openvpn")
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

# Function to escalate user privileges
priv() {
    for (( i=1; i<=3; i++ )); do
        read -rs VARIABLE < $(wofi --password --prompt "<PASSWORD>" | tr -d '\n')
        sha1pass <<<"$VARIABLE"
    done
    return $sha1pass
}

# Function to get a list of WireGuard connections
get_connections() {
    local type="$1"
    local connections

    if [[ "$type" == "active" ]]; then
        connections=$(wg show interfaces | awk '/^interface/ {print $2}')
    elif [[ "$type" == "available" ]]; then
        connections=$(wg show all | awk '/^interface/ {print $2}')
    fi

    echo "$connections"
}

# Function to activate/deactivate OpenVPN/WireGuard connections
connection() {
    local type="$1"
    local wg_status=$(wg show "$conn" | awk '/^  interface:/ {print $3}')
    local iface="wg0"

    for iface in $(ifconfig | cut -d ' ' -f1 | tr ':' '\n' | awk NF); do
        +=("$iface")

        if [[ -z $(sudo wg show) ]]
            notify-send -u low -a "WireGuard" "$conn: $ip_address"
        elif [[ "$iface" ==  ("interface: $iface" | tr -d " " | "listening port: ") ]]; then

        else



    local connections=$(get_connections "$type")

    for conn in $connections; do
        local status=$(wg show "$conn" | awk '/^  interface:/ {print $3}')
        local ip_address=$(wg show "$conn" | awk '/^  public key:/ {print $4}')

        if [[ "$status" == "up" && -n "$ip_address" ]]; then
            notify-send -u low -a "WireGuard" "$conn: $ip_address"
        elif [[ "$status" == "down" ]]; then
            notify-send -u normal -a "WireGuard" "$conn"
        fi
    done
}

# Main function to handle user input
wireguard() {
    local selected="$1"

    case "$selected" in
        "Active")
            connection #"active"
            ;;
        "Menu")
            connection "available" | wofi --dmenu
            ;;
        "Toggle")
            if [[ $# -ne 2 ]]; then
                notify-send -u critical -a "WireGuard" "Usage: $0 toggle NAME"
                exit 1
            fi
            toggle_connection "$2"
            ;;
        "Setup Proxy")
            if [[ $# -ne 5 ]]; then
                notify-send -u critical -a "WireGuard" "Usage: $0 setup-proxy NAME TYPE HOST PORT"
                exit 1
            fi
            setup_proxy "$2" "$3" "$4" "$5"
            ;;
        "Disable Proxy")
            if [[ $# -ne 2 ]]; then
                notify-send -u critical -a "WireGuard" "Usage: $0 disable-proxy NAME"
                exit 1
            fi
            disable_proxy "$2"
            ;;
        "Reload")
            notify-send -u low -a "WireGuard" "$(print_connections "available")\nreload\nquit" | wofi --dmenu
            ;;
        *)
            cleanup
            ;;
    esac
}

# Main function to display the vpn menu and handle user input
main() {
	local lfg=false
    local menu=(
        "Active"
        "Toggle"
        "Setup Proxy"
        "Disable Proxy"
        "Reload"
        "EDIT CONNECTION"
        "ACTIVATE CONNECTION"
        "SPEED TEST"
        "SYSTEM HOSTNAME"
        "<----DONE---->")

    if requirements; then
        lfg=true
    fi

    while $lfg; do
        local selected=$(printf "%s\n" "${menu[@]}" | wofi --dmenu --prompt "<WIREGUARD-MENU>" | tr -d '\n')

        if [[ -z "$selected" ]]; then
            # Allow the escape key to return to the prior menu if in a submenu
            if [[ "${#menu[@]}" -gt 8 ]]; then
                continue
            else
                break
            fi
        fi

        wireguard "$selected"
    done

    # Handles vpn inforamtion back to waybar
    local vpn_name=$(get_vpn_status)
    show_vpn_status_details "$vpn_name"
}

# Start of Script
main
