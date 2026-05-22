#!/usr/bin/env bash
# Example: using the bash library
LIB_DIR="$(dirname "${BASH_SOURCE[0]}")/../lib"
source "$LIB_DIR/common.sh"
source "$LIB_DIR/system.sh"
source "$LIB_DIR/network.sh"

check_root
log_info "System: $(get_os_version)"
log_info "CPU: $(get_cpu_pct)% | Memory: $(get_mem_pct)% | Disk: $(get_disk_pct /)%"
log_info "Primary IP: $(get_primary_ip)"

if wait_for_port 22 localhost 5; then
    log_ok "SSH is available"
else
    log_warn "SSH not available"
fi
