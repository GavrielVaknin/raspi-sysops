#!/usr/bin/env bash
# provision-user.sh is a script that allows a user to create a user, UID, and a group all in one line.
# Usage: sudo ./provision-user.sh <username> <uid> <group>
# Example: sudo ./provision-user.sh johndoe 5002 wheel
# Author - Gavriel Vaknin

set -euo pipefail
if [  "${EUID}" -ne 0  ]; then
	echo "Error: Sudo access is needed."
	exit 1
fi

USERNAME="${1:-}"
USER_UID="${2:-}"
USER_GROUP="${3:-}"
SCRIPT_NAME="$(basename "${0}" .sh)"
LOG_FILE="/var/log/${SCRIPT_NAME}.log"

if [  -z "${USERNAME}"  ] || [  -z "${USER_UID}"  ] || [  -z "${USER_GROUP}"  ]; then
	echo "Usage: sudo $0 <username> <uid> <group>" >&2
	echo "Example: sudo $0 johndoe 5002 wheel" >&2
	exit 1
fi

if ! getent group "${USER_GROUP}" >/dev/null 2>&1; then
	echo "Error: group '${USER_GROUP}' does not exist" >&2
	exit 1
fi

if id "${USERNAME}" >/dev/null 2>&1; then
	echo "Error: user '${USERNAME}' already exists" >&2
	exit 1
fi

useradd -m -u "${USER_UID}" "${USERNAME}"
trap 'userdel -r "${USERNAME}" 2>/dev/null' ERR
usermod -aG "${USER_GROUP}" "${USERNAME}"
chage -d 0 "${USERNAME}"
trap - ERR

echo "$(date) - Created user: ${USERNAME} | UID: ${USER_UID} | Group: ${USER_GROUP}" >> "${LOG_FILE}"
echo "User ${USERNAME} was created successfully and added to ${USER_GROUP}" 
