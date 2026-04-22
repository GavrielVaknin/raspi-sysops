#!/usr/bin/env bash


# =============================================
# system_audit.sh - Basic Linux System Audit
# Author: Gavriel Vaknin
# Description: Collects key system info and
#              saves it to a timestamped report
# =============================================
# Requires: systemd, util-linux. Tested on Ubuntu 22.04+, AlmaLinux 9.

set -euo pipefail

REPORT_DIR="$(dirname "$0")/reports"
mkdir -p "$REPORT_DIR"
REPORT_FILE="$REPORT_DIR/audit_$(date +%Y-%m-%d_%H-%M-%S).txt"

{
	echo "===== SYSTEM AUDIT REPORT ====="
	echo "Date: $(date)"
	echo ""
	echo "===== HOSTNAME & OS ====="
	
		if command -v hostnamectl >/dev/null 2>&1; then
			hostnamectl
		else
			echo "(hostnamectl command not available on this system)"
		fi

	echo ""
	echo "===== CPU & Memory ====="
	lscpu | grep -E "Model name|CPU\(s\)"
	free -h
	echo ""
	echo "===== Disk Usage ====="
	df -h
	echo ""
	echo "===== Logged in users ====="
	who
	echo ""
	echo "===== Last 5 logins ====="
	
		if command -v last >/dev/null 2>&1; then
			last -n 5
		else
			echo "(last command not available on this system)"
		fi

	echo ""
	echo "===== Running Services ====="
	systemctl list-units --type=service --state=running
	echo ""
} > "$REPORT_FILE"

echo "Audit Complete. Report saved to: $REPORT_FILE"

