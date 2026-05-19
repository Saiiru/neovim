#!/usr/bin/env bash
set -euo pipefail

read -r _ u1 n1 s1 i1 w1 x1 y1 z1 _ < /proc/stat
t1=$((u1 + n1 + s1 + i1 + w1 + x1 + y1 + z1))
idle1=$((i1 + w1))

sleep 0.15

read -r _ u2 n2 s2 i2 w2 x2 y2 z2 _ < /proc/stat
t2=$((u2 + n2 + s2 + i2 + w2 + x2 + y2 + z2))
idle2=$((i2 + w2))

dt=$((t2 - t1))
di=$((idle2 - idle1))

if (( dt <= 0 )); then
  printf " 0%%%%"
  exit 0
fi

usage=$(( (100 * (dt - di)) / dt ))
printf " %d%%%%" "$usage"
