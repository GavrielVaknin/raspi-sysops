#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
    echo "Error: root access required for full audit" >&2
    exit 1
fi

STATE_FILE="/var/lib/log-monitor/last_check"
ALERT_LOG="/var/log/log-monitor-alerts.log"
PRIORITY="err"
LOGROTATE_CONF="/etc/logrotate.d/log-monitor"

if [[ ! -f "$LOGROTATE_CONF" ]]; then
    cat << 'EOF' > "$LOGROTATE_CONF"
/var/log/log-monitor-alerts.log {
    weekly
    rotate 4
    compress
    missingok
    notifempty
}
EOF
echo "Installed logrotate config at $LOGROTATE_CONF"

fi

if [[ -f "$STATE_FILE" ]]; then
    last_check=$(cat "$STATE_FILE")
else
    last_check=$(date -u -d "10 minutes ago" +%Y-%m-%dT%H:%M:%S)
fi

this_check=$(date -u +%Y-%m-%dT%H:%M:%S)

new_errors=$(journalctl --since "$last_check" -p "$PRIORITY" --no-pager -o short-iso --utc)

if [[ -n "$new_errors" ]]; then
    {
        echo "=== $(date -u +%Y-%m-%dT%H:%M:%S) - new $PRIORITY + entries since $last_check ==="
        echo "$new_errors"
        echo

    } >> "$ALERT_LOG"

echo "log-monitor: found new $PRIORITY + log entries, see $ALERT_LOG"

fi

mkdir -p "$(dirname $STATE_FILE)"
echo "$this_check" > "$STATE_FILE"
