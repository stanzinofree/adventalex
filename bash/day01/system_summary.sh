#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

#=== System Summary ===
#Host: my-server
#User: alex
#Uptime: up 3 days, 2 hours
#Date: 2025-12-14 11:32
#Disk (/): 120G free
#

echo "=== System Summary ==="
echo "Host: $(hostname)"
echo "User: $(whoami)"
echo "Uptime: $(uptime)"
echo "Date: $(date)"
echo "Disk (/): $(df -h /)"
