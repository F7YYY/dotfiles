#!/usr/bin/env bash
#
# WireGuard abstraction layer for waybar and wofi
#
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
    required_tools=("wofi" "wg" "wg-quick" "wireproxy" "notify-send")
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

# Function to print WireGuard connections
print_connections() {
    local type="$1"
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

# Function to toggle the WireGuard connection status
toggle_connection() {
    local conn="$1"
    local status=$(wg show "$conn" | awk '/^  interface:/ {print $3}')

    if [[ "$status" == "up" ]]; then
        wg-quick down "$conn"
        notify-send -u normal -a "WireGuard" "Disconnected: $conn"
    elif [[ "$status" == "down" ]]; then
        wg-quick up "$conn"
        notify-send -u low -a "WireGuard" "Connected: $conn"
    else
        notify-send -u critical -a "WireGuard" "Error: Connection not found."
        exit 1
    fi
}

# Function to set up proxy for a specific WireGuard connection using wireproxy
setup_proxy() {
    local conn="$1"
    local proxy_type="$2"
    local proxy_host="$3"
    local proxy_port="$4"

    # Set up proxy for the specific WireGuard connection using wireproxy
    # The exact implementation here will depend on how wireproxy is configured and used.
    # Please consult the wireproxy documentation for proper usage.
    # Example usage:
    # wireproxy setup --connection "$conn" --type "$proxy_type" --host "$proxy_host" --port "$proxy_port"
}

# Function to disable proxy for a specific WireGuard connection using wireproxy
disable_proxy() {
    local conn="$1"

    # Disable proxy for the specific WireGuard connection using wireproxy
    # The exact implementation here will depend on how wireproxy is configured and used.
    # Please consult the wireproxy documentation for proper usage.
    # Example usage:
    # wireproxy disable --connection "$conn"
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
            f
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

# Main function to display the wireguard menu and handle user input
main() {
	local lfg=false
    local menu=(
        "Active"
        "Toggle"
        "Setup Proxy"
        "Disable Proxy"
        "Reload"
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
}

# Start of Script
main
