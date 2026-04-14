#!/bin/bash


# =============================================
# system_audit.sh - Basic Linux System Audit
# Author: Gavriel Vaknin
# Description: Collects key system info and
#              saves it to a timestamped report
# =============================================

REPORT_DIR="$(dirname "$0")/reports"
mkdir -p "$REPORT_DIR"
REPORT_FILE="$REPORT_DIR/audit_$(date +%Y-%m-%d_%H-%M-%S).txt"


echo "===== SYSTEM AUDIT REPORT =====" > "$REPORT_FILE"
echo "Date: $(date)" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "--- Hostname & OS ---" >> "$REPORT_FILE"
hostnamectl >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "--- CPU & Memory ---" >> "$REPORT_FILE"
lscpu | grep -E "Model name|CPU\(s\)" >> "$REPORT_FILE"
free -h >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "--- Disk Usage ---" >> "$REPORT_FILE"
df -h >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "--- Logged in users ---" >> "$REPORT_FILE"
who >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "--- Last 5 logins ---" >> "$REPORT_FILE"
last -n 5 >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "--- Running Services ---" >> "$REPORT_FILE"
systemctl list-units --type=service --state=running >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "Audit Complete. Report saved to: $REPORT_FILE"

