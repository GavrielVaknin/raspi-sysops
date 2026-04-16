#!/bin/bash

# =============================================
# provision_user.sh - User Provisioning Script
# Author: Gavriel Vaknin
# Description: Creates a new user, assigns them
#              to a group, and enforces password
#              change on first login
# =============================================

if [ "$EUID" -ne 0 ]; then
	echo "Error: please run as root"
	exit 1
fi

USERNAME=$1
USER_UID=$2
USER_GROUP=$3
LOG_FILE="/var/log/provision_user.log"

if [ -z "$USERNAME" ] || [ -z "$USER_UID" ] || [ -z "$USER_GROUP" ]; then
	echo "Usage: ./provision_user.sh <username> <uid> <group>"
	exit 1
fi

if id "$USERNAME" &>/dev/null 2>&1; then
	echo "Error: user $USERNAME already exists"
	exit 1
fi

