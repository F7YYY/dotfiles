#<< WIP
ipvxconfig() {
    local lfg=true
    local options=(
        "IPv4 Configuration"
        "IPv6 Configuration"
        "Automatically connect"
        "Available to all users"
        "<----DONE---->")

    while $lfg; do
        local selected=$(traverse | wofi --dmenu --prompt "<IPvX_Configuration>" <<< "${options[@]/%/$'\n'}" | tr -d '\n')

        if [[ -n "$selected" ]]; then
            case "$selected" in
                "IPv4 Configuration")
                    local ipv4_choice=$(echo -e "Auto Configure (Default)" "Specify Address" | wofi --dmenu --prompt "<IPv4_Configuration>")

                    case "$ipv4_choice" in
                        "Specify Address")
                            read -p "Enter IPv4 address: " ipv4_address
                            # Code to configure specified IPv4 address
                            nmcli connection modify 'Wired Connection' ipv4.addresses "$ipv4_address"
                            nmcli connection up 'Wired Connection'
                            ;;
                        *)
                            # Code for auto configuration
                            nmcli connection up 'Wired Connection'
                            ;;
                    esac
                    ;;

                "IPv6 Configuration")
                    local ipv6_choice=$(echo -e "Auto Configure (Default)" "Specify Address" | wofi --dmenu --prompt "<IPv6_Configuration>")

                    case "$ipv6_choice" in
                        "Specify Address")
                            read -p "Enter IPv6 address: " ipv6_address
                            # Code to configure specified IPv6 address
                            nmcli connection modify 'Wired Connection' ipv6.addresses "$ipv6_address"
                            nmcli connection up 'Wired Connection'
                            ;;
                        *)
                            # Code for auto configuration
                            ;;
                    esac
                    ;;

                "Automatically connect")
                    local auto_connect_choice=$(echo -e "yes" "no" | wofi --dmenu --prompt "<Automatically connect>")

                    case "$auto_connect_choice" in
                        "yes")
                            # Code to enable automatic connection
                            nmcli networking on
                            ;;
                        "no")
                            # Code to disable automatic connection
                            nmcli networking off
                            ;;
                    esac
                    ;;

                "Available to all users")
                    local all_users_choice=$(echo -e "yes" "no" | wofi --dmenu --prompt "<Available to all users>")

                    case "$all_users_choice" in
                        "yes")
                            # Code to enable availability to all users
                            nmcli connection modify 'Wired Connection' connection.permissions 'all'
                            ;;
                        "no")
                            # Code to disable availability to all users
                            nmcli connection modify 'Wired Connection' connection.permissions ''
                            ;;
                    esac
                    ;;
                *)
                    $continue=false
                    ;;
            esac
        fi
    done
}

WiFi() {
    local continue=true

    while $continue; do
        options=(
            "EDIT WiFi CONNECTION"
            "Device Name"
            "SSID"
            "MODE"
            "Secrity"
            "Cloned MAC Address"
            "MTU: 1500 (DEFAULT)"
            "802.1X Security"
            "EAP|PAP|CHAP|MSCHAP|MSCHAPv2"
            "Point-to-Point Encryption (MPPE)"
            "Allow BSD data compression"
            "Allow Deflate data compression"
            "Use TCP header compression"
            "Send PPP echo packets"
            "<----DONE---->"
        )

        local selection=$(traverse | wofi --dmenu --prompt "WiFi Menu:" <<< "${options[@]}/%/$'\n'")

        case "$selection" in
            "EDIT WiFi CONNECTION")
                profile_name=""
                while [[ -z "$profile_name" ]]; do
                    profile_name=$(traverse | wofi -p "WiFi Profile Name:")
                done
                ;;
            "Device Name")
                device_name=""
                while true; do
                    device_options=($(iwconfig | awk '/^[a-zA-Z0-9]+:/ {print $1}'))
                    device_name=$(traverse | wofi --dmenu --prompt "Device Name:" <<< "${device_options[@]/%/$'\n'}")

                    if iwconfig | grep -q "$device_name"; then
                        break
                    else
                        notify-send "Invalid Device Name!"
                    fi
                done
                ;;
            "SSID")
                ssid=""
                while true; do
                    ssid_options=($(iwlist "$device_name" scanning | awk -F '"' '/ESSID:/ {print $2}'))
                    ssid=$(traverse | wofi --dmenu --prompt "SSID:" <<< "${ssid_options[@]/%/$'\n'}")

                    if iwlist "$device_name" scanning | grep -q "$ssid"; then
                        break
                    else
                        notify-send "Invalid SSID!"
                    fi
                done
                ;;
            "MODE")
                mode_options=("Client" "Access Point" "Ad-Hoc Network")
                wofi --dmenu --prompt "MODE:" <<< "${mode_options[@]}/%/$'\n'"
                read -r mode
                if [[ -n "$mode" ]]; then
                    # Enable and configure mode feature(s)
                                            notify-send "Invalid MAC Address!"
                fi
                ;;
            "Secrity")
                security_options=("None" "WPA & WPA2 Personal" "WPA3 Personal" "WPA & WPA2 Enterprise" "LEAP" "Enhance Open (OWE)")
                wofi --dmenu --prompt "Security:" <<< "${security_options[@]}/%/$'\n'"
                read -r security
                if [[ -n "$security" ]]; then
                    # Enable and configure security feature(s)
                    login "$security"
                fi
                ;;
            "Cloned MAC Address")
                "Cloned MAC Address"
                mac_address=""
                while true; do
                    mac_address=$(traverse | wofi -p "Cloned MAC Address:")
                    if ifconfig "$device_name" hw ether "$mac_address"; then
                        break
                    else
                        notify-send "Invalid MAC Address!"
                    fi
                done
                ;;
            "MTU: 1500 (DEFAULT)")
                mtu=""
                while true; do
                    mtu=$(traverse | wofi -p "MTU: 1500 (DEFAULT):")
                    if [[ "$mtu" =~ ^[0-9]+$ && "$mtu" -ge 64 && "$mtu" -le 4352 ]]; then
                        break
                    fi
                done
                ;;
            "802.1X Security")
                ;;
            "EAP|PAP|CHAP|MSCHAP|MSCHAPv2")
                ;;
            "Point-to-Point Encryption (MPPE)")
                ;;
            "Allow BSD data compression")
                ;;
            "Allow Deflate data compression")
                ;;
            "Use TCP header compression")
                ;;
            "Send PPP echo packets")
                ;;
            *)
                $continue=false
                ;;
        esac
    done
}
#WIP

<< DIAGRAM
<< LEGEND
{} = scope
"" = wofi input string field
'' = selectable option(s) in menu
** = code specified selection
> = wofi submenu
@ = return to prior menu
@@ = return to main menu
▂▄▆█ = graph from weak to strong
[] = function call
LEGEND

WiFi() {
    *[traverse]*
    > "EDIT WiFi CONNECTION" {
        "WiFi Profile Name:" {
            *validate [traverse], but "" must be filled*
}
        "Device Name:" {
            *loop > until [traverse] and users "" corresponds to correct device in system*
            '*if list available, prioritized, Wifi hardware selected, then use selected device, else @*'
}
        > "SSID:" {
            *loop > until [traverse] and users "" corresponds to correct SSID in list, then @*
}
        > "MODE:" {
            'Client'
            'Access Point'
            'Ad-Hoc Network'
            *if [traverse] of users input "" or '' specified, then enable feature(s) and auto configure*
}
        > "Secrity" {
            'None'
            'WPA & WPA2 Personal'
            'WPA3 Personal'
            'WPA & WPA2 Enterprise'
            'LEAP'
            'Enhance Open (OWE)'
            *if [traverse] of users input "" or '' specified, then enable feature(s) and auto configure*
}
        [login]
        > "Cloned MAC Address:" {
            *loop > until [traverse] and users "" contains existing MAC Address, then use specified MAC, else notify-send Invalid MAC Address! and @*
}
        > "MTU: 1500 (DEFAULT)" {
            *loop > until [traverse] and users "" contains only numbers between 64 and 4352, then @*
}
        > "802.1X Security" {
            'Enable 802.1X Security'
            *if [traverse] of user input "" specifies enable or '' is selected, then enable 802.1X security feature and @.
}
        > "EAP|PAP|CHAP|MSCHAP|MSCHAPv2" {
            *if [traverse] of users input "" specifies any selection(s) (between |) in >"" with spaces, then enable feature(s) and @*
}
        > "Point-to-Point Encryption (MPPE)" {
            'yes'
            'no'
            *if [traverse] of users input "" or '' specifies yes, then next >*
            > "MPPE" {
                'Require 128-bit Encryption'
                'Use stateful MPPE'
                *if [traverse] of users input "" or '' specifies '', then then enable feature(s)*
}}
        > "Allow BSD data compression" {
            'yes'
            'no'
            *if [traverse] of users input "" or '' specifies yes, then enable feature(s)*
}
        > "Allow Deflate data compression" {
            'yes'
            'no'
            *if [traverse] of users input "" or '' specifies yes, then enable feature(s)*
}
        > "Use TCP header compression" {
            'yes'
            'no'
            *if [traverse] of users input "" or '' specifies yes, then enable feature(s)*
}
        > "Send PPP echo packets" {
            'yes'
            'no'
            *if [traverse] of users input "" or '' specifies yes, then enable feature(s)*
}
        [ipvxconfig]
}

menu() {
	'EDIT CONNECTION' {
		*if no hardware or software available to toggle connections, then notify-send You Done Fucky Wucky!*
		*else >"
		> "DSL|ETH0|INFB|WIFI|BOND|BRID|IPTUN|MACs|TEAM|VETH|VLAN|PROXY" {
			*if [traverse] users input "" specifies any, one selection (between |) in >"", then create that type of connection using helper functions, else @*
		}
	}

	'Activate CONNECTION' {
		*if no connection is created that can establish a network connection, then then notify-send Activate Connection and @@*
		*else >*
		> "Activate" {
			*return fresh network list based on 'EDIT CONNECTION'*
			*return ▂▄▆█ strength and full network details*
			*return which network(s) are currently active with star*
			*user can repeatedly toggle network(s) connection with/without star*
			'*list available, prioritized, DSL networks*'
			'*list available, prioritized, Ethernet networks*'
			'*list available, prioritized, InfinityBands*'
			'*list available, prioritized, WiFi networks*'
			'*list available, prioritized, Bonds*'
			'*list available, prioritized, Bridges*'
			'*list available, prioritized, IP-Tunnels*'
			'*list available, prioritized, MACsecurities*"
			'*list available, prioritized, Teams*'
			'*list available, prioritized, Veth*'
			'*list available, prioritized, VLANs*'
			'*list available, prioritized, proxies (including wireproxy and TOR)*'
			'*list available, prioritized, VPNs (including wireguard*'
			*if network connection requires password, then loop prompt "Enter Password" until network connection validated, and every incorrect password notify-send Incorrect Password*
			*@@ only when user hits escape*
		}
	}
}
DIAGRAM


# Function to sort WiFi networks based on signal strength
sort_wifi_networks() {
    nmcli device wifi list | awk '{print $1, $3, $4, $6}' | sort -k2nr
}

# Function to get WiFi interface name
get_wifi_interface() {
    ifconfig -a | grep UP | sed 's/:.*//;/^$/d'
}

# Function to toggle WiFi interface enable/disable
toggle_wifi_interface() {
    local wifi_interface=$(get_wifi_interface)
    local interface_state=$(nmcli radio wifi | awk '/^enabled/ {print $1}')
    nmcli radio wifi "$([[ "$interface_state" == "enabled" ]] && echo "off" || echo "on")"
    notify-send -u normal -a "WiFi Interface Toggled" "WiFi interface is now $([[ "$interface_state" == "enabled" ]] && echo "disabled" || echo "enabled")."
}

# Function to handle WiFi network connection with password prompt
connect_to_wifi_network() {
    local wifi_info=$(nmcli device wifi list)
    local interface=$(get_wifi_interface)
    local selected_wifi="$(traverse | wofi --dmenu --prompt "WiFi List:" --width 1000 --height 400 <<< "$wifi_info")"

    if [[ -n "$wifi_info" ]]; then
        if [[ -n "$selected_wifi" ]]; then
            wofi --dmenu --password --prompt "Enter WiFi Password:" | tr -d '\n'
        fi
    elif [[ -n "$interface" ]]; then
        toggle_wifi_interface
        wofi --dmenu --prompt "Enable WiFi Interface: $interface" <<< "Yes" "No"
    else
        notify-send -u critical -a "Error:" "WiFi Interface NOT Found!"
        return 1
    fi
}
