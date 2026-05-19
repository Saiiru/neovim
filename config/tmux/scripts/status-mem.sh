#!/usr/bin/env bash
set -euo pipefail

awk '
/MemTotal:/ { total=$2 }
/MemAvailable:/ { avail=$2 }
END {
  used = total - avail
  pct = int((used / total) * 100)
  printf "󰍛 %d%%%%", pct
}
' /proc/meminfo
