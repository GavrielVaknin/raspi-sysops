# User provisioning

Creates a new user with a specific UID, assigns them to an existing group, and enforces a password change on first login. All successful operations are logged to `/var/log/`.

## Usage

```bash
sudo ./provision-user.sh <username> <uid> <group>
```

Example:

```bash
sudo ./provision-user.sh johndoe 5002 wheel
```

After running this script, set an initial password for the user:

```bash
sudo passwd johndoe
```

The user will be prompted to change it on their first login.

## Validation and error handling

- Must be run as root
- All three arguments must be provided
- Target group must already exist
- Username must not already be taken
- If any step fails after user creation, the user is deleted (rollback via `ERR` trap)
- Only logs on full success

## Requirements

- Linux with `useradd`, `usermod`, `chage`, `getent` (standard on most distros)
- Tested on Ubuntu 25.10 and AlmaLinux 9
