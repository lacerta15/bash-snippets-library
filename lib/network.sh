#!/usr/bin/env bash
# =============================================================
#  lib/network.sh — Network utility functions
# =============================================================

get_primary_ip() {
    ip route get 8.8.8.8 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="src") print $(i+1); exit}'
}

get_primary_iface() {
    ip route | awk '/^default/{print $5; exit}'
}

is_port_listening() {
    ss -tlnp "sport = :$1" 2>/dev/null | grep -q LISTEN
}

resolve_hostname() {
    dig +short "$1" 2>/dev/null | head -1 ||     nslookup "$1" 2>/dev/null | awk '/^Address: /{print $2}' | head -1
}

test_connectivity() {
    local host="${1:-8.8.8.8}"
    ping -c1 -W2 "$host" &>/dev/null && echo "ok" || echo "fail"
}

get_open_ports() {
    ss -tlnp | awk 'NR>1{split($4,a,":");print a[length(a)]}' | sort -nu
}

scan_port() {
    local host="$1" port="$2"
    timeout 2 bash -c "echo >/dev/tcp/$host/$port" 2>/dev/null && echo "open" || echo "closed"
}
