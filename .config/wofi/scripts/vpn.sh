#!/usr/bin/env bash
#
# WOFI WAYBAR VPN #
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

# Function to check if the required tools are installed
requirements() {
    local required_tools=("notify-send" "wofi" "waybar" "nmcli" "speedtest" )
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

# Function to safely get VPN status
get_vpn_status() {
    local vpn_info=$(nmcli -t -f NAME,TYPE,DEVICE connection show --active | grep 'vpn' | awk -F ':' '{print $1}')
    echo "$vpn_info"
}

# Function to safely get VPN details
get_vpn_details() {
    local vpn_name="$1"
    local vpn_details=$(nmcli -t -f NAME,GENERAL.STATE,GENERAL.DEFAULT,GENERAL.ACTIVECONNECTIONTYPE connection show "$vpn_name")
    echo "$vpn_details"
}

# Function to safely get VPN IP addresses
get_vpn_ip_addresses() {
    local vpn_name="$1"
    local vpn_details=$(get_vpn_details "$vpn_name")
    local ipv4_address=$(echo "$vpn_details" | grep 'ipv4' | awk -F ':' '{print $2}')
    local ipv6_address=$(echo "$vpn_details" | grep 'ipv6' | awk -F ':' '{print $2}')
    echo -e "IPv4: $ipv4_address\nIPv6: $ipv6_address"
}

# Function to safely get VPN device and speed information
get_vpn_device_speed_info() {
    local device_info=$(echo "$1" | grep 'device' | awk -F ':' '{print $2}')
    local speed_info=$(speedtest)
    echo -e "Device: $device_info\nSpeed: $speed_info"
}

# Function to safely show VPN status and details using Wofi
show_vpn_status_details() {
    local vpn_name="$1"
    local vpn_status=$(get_vpn_status)
    #local icon="<span foreground='#928374'></span>"
    local icon="" # Replace this with the desired icon for VPN off
    local status="Off"
    local tooltip="VPN is currently off"

    if [[ -n "$vpn_status" ]]; then
        icon="<span foreground='#928374'></span>"
        icon="" # Replace this with the desired icon for VPN on
        status="On"
        local vpn_details=$(get_vpn_details "$vpn_name")
        local vpn_ip_info=$(get_vpn_ip_addresses "$vpn_name")
        local vpn_speed_info=$(get_vpn_device_speed_info "$vpn_details")
        tooltip="VPN: $vpn_name\n$vpn_details\n$vpn_ip_info\n$vpn_speed_info"
    else
        # Return an empty string to hide the icon
        echo ""
    fi

    echo "{\"text\": \"$icon\", \"class\": \"$status\", \"tooltip-markup\": true, \"tooltip\": \"$tooltip\"}"
}

# Function to show VPN details using Wofi
show_vpn_details() {
    local vpn_status=$(get_vpn_status)
    if [[ -n "$vpn_status" ]]; then
        local vpn_list
        vpn_list=$(nmcli -t -f NAME,TYPE connection show | grep 'vpn' | awk -F ':' '{print $1}')
        local selected_vpn=$(echo "$vpn_list" | wofi --dmenu --prompt "VPN Details" | tr -d '\n')
        if [[ -n "$selected_vpn" ]]; then
            show_vpn_status_details "$selected_vpn"
        fi
    fi
}

# Function to connect to a VPN using Wofi
connect_to_vpn() {
    local vpn_list=$(nmcli -t -f NAME,TYPE connection show | grep 'vpn' | awk -F ':' '{print $1}')
    local selected_vpn=$(echo "$vpn_list" | wofi --dmenu --prompt "Connect to VPN" | tr -d '\n')
    if [[ -n "$selected_vpn" ]]; then
        nmcli connection up "$selected_vpn"
    fi
}

# Function to disconnect from the current VPN
disconnect_from_vpn() {
    local vpn_status=$(get_vpn_status)
    if [[ -n "$vpn_status" ]]; then
        nmcli connection down "$vpn_status"
    fi
}

# Function to safely delete a VPN connection
delete_vpn_connection() {
    local vpn_list=$(nmcli -t -f NAME,TYPE connection show | grep 'vpn' | awk -F ':' '{print $1}')
    local selected_vpn=$(echo "$vpn_list" | wofi --dmenu --prompt "Delete VPN connection" | tr -d '\n')
    if [[ -n "$selected_vpn" ]]; then
        nmcli connection delete "$selected_vpn"
    fi
}

# Main function to handle user input
wireguard() {
    local selected="$1"

    case "$selected" in
        "Active")
            print_connections "active"
            ;;
        "Menu")
            print_connections "available" | wofi --dmenu
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
