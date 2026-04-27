# 03 - System Backup Script

Creates a compressed `tar` archive of the system, computes a SHA256 integrity hash, and uploads both to AWS S3.

## What it excludes

- `/proc` and `/sys` — virtual filesystems, recreated by the kernel at boot
- `/tmp` — temporary files
- `/dev` — device files, recreated at boot
- `/run` — runtime data, recreated at boot

## Requirements

- Linux with `tar` and `sha256sum` (standard on most distros)
- AWS CLI installed and configured (`aws configure`)
- IAM user with permission to write to the target S3 bucket
- Run with `sudo` (needed to read system files like `/etc/shadow`)

Tested on AlmaLinux 9.

## Usage

```bash
sudo ./backup.sh
```

The script reads AWS credentials from the invoking user's home (`~/.aws/credentials`), discovered automatically via `$SUDO_USER`.
Configure AWS CLI as your normal user before running.

## Restore

A documented single-file restore drill (with SELinux context handling on AlmaLinux) is in [`../../docs/restore-drill.md`](../../docs/restore-drill.md).

Full system restore (rebuilding a working filesystem from the archive) has not been tested.
Treat this script as a file-recovery and migration tool, not a one-click bare-metal restore.

## Known limitations

- The system is backed up while running, so file consistency is not guaranteed for actively-changing files (databases, logs).
For consistency, stop services first or use a filesystem snapshot tool (LVM, btrfs).
- No retention policy is enforced by the script. Set an S3 lifecycle policy on the bucket to control storage costs.
- No notification is sent on failure. For scheduled runs, wrap with a notification mechanism (email, webhook).
- The IAM user used here has broad S3 permissions for simplicity. Production setups should scope to a least-privilege policy on the specific bucket only.

## Skills demonstrated

- Bash strict mode (`set -euo pipefail`)
- EXIT trap for cleanup
- Subshell pattern for portable file paths
- Portable credentials handling via `$SUDO_USER`
- File compression and archival with `tar`
- Cryptographic integrity verification with `sha256sum`
- AWS S3 CLI usage
