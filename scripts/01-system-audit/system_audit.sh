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
