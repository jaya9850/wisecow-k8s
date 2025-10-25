#!/usr/bin/env bash
# app_health_check.sh - simple HTTP health check script
# usage: ./app_health_check.sh <url> <expected_status>

URL="${1:-http://localhost:4499/}"
EXPECTED="${2:-200}"
LOG="./app_health.log"

timestamp(){ date '+%Y-%m-%d %H:%M:%S'; }

status=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "$URL")
if [ "$status" = "$EXPECTED" ]; then
  echo "$(timestamp) - UP - $URL returned $status" | tee -a "$LOG"
  exit 0
else
  echo "$(timestamp) - DOWN - $URL returned $status (expected $EXPECTED)" | tee -a "$LOG"
  exit 2
fi
