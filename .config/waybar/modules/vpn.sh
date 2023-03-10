#!/usr/bin/env bash

vpn() {
    if curl -s https://www.cloudflare.com/cdn-cgi/trace | grep -Eq 'warp=(on|plus)'; then
        icon="<span foreground='#928374'></span>"
        class=on
    else
        icon="<span foreground='#928374'></span>"
        class=off
    fi
    printf '{"text": " %s ", "class": "%s"}\n' "$icon" "$class"
}

if grep '^home-' /etc/hostname > /dev/null; then
    while true; do
        vpn
        sleep 5m
    done
fi
