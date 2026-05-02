#!/usr/bin/env bash

# ==========================================
# backup.sh - System Backup and S3 upload
# Author: Gavriel Vaknin
# Description: Creates a compressed image of
#              the system and upload it to
#              AWS S3 for safekeeping. Allows
#              rollback to a previous known
#              working state.
#===========================================

set -euo pipefail

if [  "$EUID" -ne 0 ]; then
	echo "Error: root access needed."
	exit 1
fi

HOSTNAME=$(hostname)
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="${HOSTNAME}-${DATE}.tar.gz"
S3_BUCKET="s3://raspi-backup-gavriel"
LOG_FILE="/var/log/backup.log"

trap 'rm -f "/tmp/${BACKUP_FILE}" "/tmp/${BACKUP_FILE}.sha256"' EXIT

# Exclude virtual and runtime filesystem that don't need backing up
# /proc and /sys - virtual filesystem, created by kernel at boot
# /tmp - temporary files, not neede after reboot
# /dev - device files, recreated at boot
# /run - run time data, recreated at boot

tar -czf "/tmp/${BACKUP_FILE}" \
	--exclude=/proc \
	--exclude=/sys \
	--exclude=/tmp \
	--exclude=/dev \
	--exclude=/run \
	/

( cd /tmp && sha256sum "${BACKUP_FILE}" > "${BACKUP_FILE}.sha256" )

if [  -n "${SUDO_USER:-}"  ]; then
	USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
	USER_HOME="/root"
fi
export AWS_SHARED_CREDENTIALS_FILE="${USER_HOME}/.aws/credentials"


aws s3 cp "/tmp/${BACKUP_FILE}" "${S3_BUCKET}/${BACKUP_FILE}"
aws s3 cp "/tmp/${BACKUP_FILE}.sha256" "${S3_BUCKET}/${BACKUP_FILE}.sha256"

echo "$(date) - Backup Uploaded: ${BACKUP_FILE}" >> "$LOG_FILE"

echo "Backup complete: ${BACKUP_FILE} uploaded to ${S3_BUCKET}"

