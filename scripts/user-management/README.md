# 02 - User Provisioning Script

## What it does
Creates a new user on the system with a specific UID, assigns them
to an existing group, and enforces a password change on first login.
All successful operations are logged with a timestamp.

## Usage
sudo ./provision_user.sh <username> <uid> <group>

Example:
sudo ./provision_user.sh johndoe 5002 wheel

## Validation and error handling
- Must be run as root
- All three arguments must be provided
- Target group must already exist
- Username must not already be taken
- If any step fails after user creation, the user is deleted (rollback)
- Only logs on full success

## Skills demonstrated
- Bash scripting with input validation
- Linux user and group management
- Exit codes and error handling
- Rollback logic on failure
- System logging to /var/log
