#!/usr/bin/env bash


# =============================================
# system-audit.sh - Basic Linux System Audit
# Author: Gavriel Vaknin
# Description: Collects key system info and
#              saves it to a timestamped report
# =============================================
# Requires: systemd, Tested on Ubuntu 22.04+, AlmaLinux 9.

set -euo pipefail

if [[ "${EUID}" -ne 0  ]]; then
	echo "Error: root access require for full audit" >&2
	exit 1
fi

REPORT_DIR="$(dirname "$0")/reports"
mkdir -p "${REPORT_DIR}"
REPORT_FILE="${REPORT_DIR}/audit_$(date +%Y-%m-%d_%H-%M-%S).txt"

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
	echo "===== Logged In Users ====="
	who
	echo ""
	
	echo "===== Last 5 Logins ====="
	journalctl _COMM=systemd-logind --since "7 days ago" -n 5 --no-pager 2>/dev/null \
		|| echo "(No logging records)"
	echo ""
	echo "===== Failed Login Attempts (last 5) ====="
	journalctl -u ssh -u sshd --grep "Failed|Invalid user" -n 5 --no-pager 2>/dev/null \
		|| echo "(no failed login records)"
	echo ""

	echo "===== Pending Updates ====="
	if command -v apt >/dev/null 2>&1; then
		apt list --upgradable 2>/dev/null | tail -n +2
	elif command -v dnf >/dev/null 2>&1; then
		dnf check-update --quiet || true
	elif command -v pacman >/dev/null 2>&1; then
		checkupdates 2>/dev/null || echo "(No updates or checkupdates not installed)"
	elif command -v apk >/dev/null 2>&1; then
		apk version -l '<' 2>/dev/null
	else
		echo "(No supported package manager found)"
	fi

	echo ""
	echo "===== Listening Ports ====="
	ss -tulpn
	echo ""
	echo "===== Running Services ====="
	systemctl list-units --type=service --state=running
	echo ""
} > "${REPORT_FILE}"

ls -1t "${REPORT_DIR}"/audit_*.txt | tail -n +21 | xargs -r rm

echo "Audit Complete. Report saved to: ${REPORT_FILE}"

