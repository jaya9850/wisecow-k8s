#!/usr/bin/env bash
# Simple system health logger — system_health.sh

LOGFILE="./system_health.log"
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80

timestamp() { date '+%Y-%m-%d %H:%M:%S'; }

echo "$(timestamp) - Health check started" >> "$LOGFILE"

# CPU usage (approx)
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk -F',' '{print $4}' | awk '{print $1}')
CPU_USAGE=$(printf "%.0f" "$(echo "100 - $CPU_IDLE" | bc)")

# Memory percent used
MEM_USED=$(free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}')

# Disk percent used on root
DISK_USED=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')

echo "$(timestamp) - CPU: ${CPU_USAGE}%, MEM: ${MEM_USED}%, DISK(/): ${DISK_USED}% " >> "$LOGFILE"

if [ "$CPU_USAGE" -ge "$CPU_THRESHOLD" ]; then
  echo "$(timestamp) - ALERT: CPU threshold exceeded: ${CPU_USAGE}%" | tee -a "$LOGFILE"
fi

if [ "$MEM_USED" -ge "$MEM_THRESHOLD" ]; then
  echo "$(timestamp) - ALERT: Memory threshold exceeded: ${MEM_USED}%" | tee -a "$LOGFILE"
fi

if [ "$DISK_USED" -ge "$DISK_THRESHOLD" ]; then
  echo "$(timestamp) - ALERT: Disk threshold exceeded: ${DISK_USED}%" | tee -a "$LOGFILE"
fi

echo "$(timestamp) - Top CPU processes:" >> "$LOGFILE"
ps -eo pid,comm,pcpu --sort=-pcpu | head -n 6 >> "$LOGFILE"
