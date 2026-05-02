# raspi-sysops

Linux sysadmin learning lab — Bash scripts and notes from running AlmaLinux on a Raspberry Pi 5 and Ubuntu on a ThinkPad.

## What's here

| Project | What it does |
|---------|--------------|
| [system-audit](scripts/system-audit/) | Generates a timestamped report of system state — hostname, CPU, memory, disk, users, services |
| [user-management](scripts/user-management/) | Provisions users with input validation, group checks, and rollback on failure |
| [system-backup](scripts/system-backup/) | Creates compressed system backups, computes a SHA256 hash, and uploads both to AWS S3 |

A documented [single-file restore drill](docs/restore-drill.md) accompanies the backup script, tested on AlmaLinux 9 with SELinux enforcing.

## Hardware & lab

- Raspberry Pi 5 (8 GB RAM), AlmaLinux 9
- Lenovo ThinkPad T470, Ubuntu 25.10
- AWS Free Tier (S3 for off-site backups)

## Skills demonstrated

- Bash scripting with strict mode (`set -euo pipefail`)
- Portable command detection (`command -v`)
- EXIT and ERR traps for cleanup and rollback
- Timestamped logging and report generation
- Linux system introspection (`hostnamectl`, `lscpu`, `free`, `df`, `systemctl`)
- User and group provisioning with validation
- File compression and archival (`tar`, `gzip`)
- Cryptographic integrity verification (`sha256sum`)
- AWS S3 CLI usage with portable credential handling
- Git workflow with Conventional Commits
- SELinux context management (`restorecon`)

## Certifications

**Earned:**
- CompTIA Network+ (April 2026)

**Planned:**
- CompTIA A+
- CompTIA Security+
- Cisco CCNA

## About

Based in Austin, TX, transitioning into IT from hands-on technical work as a garage door technician.
Years of diagnosing unfamiliar mechanical systems under time pressure, communicating fixes to non-technical customers,
and closing tickets the same day — the same workflow as a help desk role, applied to a different stack.
Open to relocating anywhere in the US for the right role.

## License

MIT — see [LICENSE](LICENSE).
