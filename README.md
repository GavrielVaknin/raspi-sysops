# raspi-sysops

Linux sysadmin learning lab — scripts and notes from running AlmaLinux on a Raspberry Pi 5 and Ubuntu on a ThinkPad.
Each project here is built to reinforce specific concepts from CompTIA A+ and Network+ studies.

## Status

Currently studying for **CompTIA A+** and **Network+**, targeting both exams by mid-May 2026.
Building Bash automation for a homelab while preparing for an entry-level IT role.

## Hardware & lab

- Raspberry Pi 5 (8 GB RAM), AlmaLinux 9
- Lenovo ThinkPad T470, Ubuntu 25.10
- AWS Free Tier (S3 for off-site backups)

## Projects

| # | Project | What it does |
|---|---------|--------------|
| 01 | [System audit](scripts/01-system-audit/) | Generates a timestamped report of system state — hostname, CPU, memory, disk, users, services |
| 02 | [User management](scripts/02-user-management/) | Provisions users with input validation, group checks, and logging |
| 03 | [Backup](scripts/03-backup/) | Creates compressed system backups and uploads them to AWS S3 |

## Skills demonstrated

- Bash scripting with strict mode (`set -euo pipefail`)
- Portable command detection (`command -v`)
- Timestamped logging and report generation
- Linux system introspection (`hostnamectl`, `lscpu`, `free`, `df`, `systemctl`)
- User and group provisioning
- File compression and archival (`tar`, `gzip`)
- AWS S3 CLI and IAM policy basics
- Git workflow with Conventional Commits

## Certifications

**Active focus:**
- CompTIA A+ (target: May 15, 2026)
- CompTIA Network+ (target: May 20, 2026)

**Planned:**
- Cisco CCNA
- CompTIA Security+

## License

MIT — see [LICENSE](LICENSE)

## About

Based in Austin, TX, transitioning into IT from hands-on technical work as a garage door technician.
Years of diagnosing unfamiliar mechanical systems under time pressure,
communicating fixes to non-technical customers, and closing tickets the same day — the same workflow as a help desk role,
applied to a different stack. Open to relocating anywhere in the US for the right role.
