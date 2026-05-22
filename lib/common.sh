#!/usr/bin/env bash
# =============================================================
#  lib/common.sh — Common utility functions
# =============================================================

# Colors
RED='\033[0;31m'; YELLOW='\033[0;33m'; GREEN='\033[0;32m'
CYAN='\033[0;36m'; RESET='\033[0m'

log_info()  { echo -e "${GREEN}[INFO]${RESET}  $(date '+%H:%M:%S') $*"; }
log_warn()  { echo -e "${YELLOW}[WARN]${RESET}  $(date '+%H:%M:%S') $*" >&2; }
log_error() { echo -e "${RED}[ERROR]${RESET} $(date '+%H:%M:%S') $*" >&2; }
log_ok()    { echo -e "${CYAN}[OK]${RESET}    $(date '+%H:%M:%S') $*"; }
die()       { log_error "$*"; exit 1; }

check_root() { [ "$(id -u)" -eq 0 ] || die "Must be run as root"; }
check_cmd()  { command -v "$1" &>/dev/null || die "Command not found: $1"; }

retry() {
    local attempts="$1" delay="$2"; shift 2
    for i in $(seq 1 $attempts); do
        "$@" && return 0
        log_warn "Attempt $i/$attempts failed. Retrying in ${delay}s..."
        sleep "$delay"
    done
    return 1
}

confirm() {
    local msg="${1:-Continue?}"
    read -rp "$msg [y/N] " ans
    [ "$ans" = "y" ]
}

timestamp()  { date '+%Y%m%d_%H%M%S'; }
human_size() { numfmt --to=iec-i --suffix=B "$1" 2>/dev/null || echo "${1}B"; }

trap_cleanup() {
    local cleanup_fn="${1:-_default_cleanup}"
    trap "$cleanup_fn" EXIT INT TERM
}
_default_cleanup() { log_info "Cleanup..."; }
