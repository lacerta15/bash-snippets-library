# bash-snippets-library
Reusable Bash functions library for system administration scripts.

## Usage
```bash
source lib/common.sh
source lib/network.sh
source lib/system.sh

log_info "Starting task..."
check_root
wait_for_port 8080 localhost 30
```
