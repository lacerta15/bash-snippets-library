#!/usr/bin/env bash
# =============================================================
#  lib/system.sh — System information functions
# =============================================================

get_cpu_pct() {
    top -bn1 | awk '/^%Cpu/{print 100-$8}' | head -1
}

get_mem_pct() {
    free | awk '/^Mem:/{printf "%.0f", $3/$2*100}'
}

get_disk_pct() {
    local path="${1:-/}"
    df "$path" | awk 'NR==2{print $5}' | tr -d '%'
}

is_service_running() {
    systemctl is-active --quiet "$1"
}

get_os_version() {
    . /etc/os-release 2>/dev/null && echo "$NAME $VERSION_ID" || uname -r
}

get_public_ip() {
    curl -s --max-time 5 https://api.ipify.org 2>/dev/null || echo "unavailable"
}

check_port_open() {
    local host="$1" port="$2" timeout="${3:-2}"
    timeout "$timeout" bash -c "echo >/dev/tcp/$host/$port" 2>/dev/null
}

wait_for_port() {
    local port="$1" host="${2:-localhost}" timeout="${3:-60}"
    local elapsed=0
    while ! check_port_open "$host" "$port" 1; do
        sleep 2; elapsed=$((elapsed+2))
        [ $elapsed -ge $timeout ] && return 1
    done
    return 0
}

get_load_avg() { uptime | awk -F'load average:' '{print $2}' | awk -F, '{gsub(/ /,"",$1);print $1}'; }
cpu_count()    { nproc 2>/dev/null || grep -c ^processor /proc/cpuinfo; }
total_ram_gb() { awk '/^MemTotal:/{printf "%.0f", $2/1024/1024}' /proc/meminfo; }
