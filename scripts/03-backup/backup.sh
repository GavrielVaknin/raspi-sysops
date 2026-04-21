#!/bin/bash
# ==========================================
# backup.sh - System Backup and S3 upload
# Author: Gavriel Vaknin
# Description: Creates a compressed image of
#              the system and upload it to
#              AWS S3 for safekeeping. Allows
#              rollback to a previous known
#              working state.
#===========================================

if [  "$EUID" -ne 0 ]; then
	echo "Error: root access needed."
	exit 1
fi

HOSTNAME=$(hostname)
DATE=$(date +%Y-%m-%d)
BACKUP_FILE="${HOSTNAME}-${DATE}.img.gz"
S3_BUCKET="s3://raspi-gavriel-backup"
LOG_FILE="/var/log/backup.log"

dd if=/dev/mmcblk0 bs=4M status=progress | gzip > "/tmp/${BACKUP_FILE}"

if [  $? -ne 0  ]; then
	echo "Error: backup failed, cleaning up..."
	rm -f "/tmp/${BACKUP_FILE}"
	exit 1
fi

aws s3 cp "/tmp/${BACKUP_FILE}" "${S3_BUCKET}/${BACKUP_FILE}"

if [  $? -ne 0  ]; then
	echo "Error: S3 upload fail."
	rm -f "/tmp/${BACKUP_FILE}"
	exit 1
fi

echo "$(date) - Backup Uploaded: ${BACKUP_FILE}" >> "$LOG_FILE"

echo "Backup complete: ${BACKUP_FILE} uploaded to ${S3_BUCKET}"

