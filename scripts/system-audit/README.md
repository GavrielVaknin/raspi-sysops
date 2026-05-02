# 01 - System Audit Script

## What it does
Collects key system information and saves it to a timestamped report file under `reports/`.

## Requirements
- Linux with systemd (Ubuntu 22.04+, AlmaLinux 9, or similar)
- `util-linux` package (for `lscpu`)
- Optional: `last` (from `wtmpdb-tools` on newer Ubuntu) — gracefully skipped if missing

Tested on Ubuntu 25.10 and AlmaLinux 9.

## Information gathered
- Hostname and OS details
- CPU model and core count
- Memory and swap usage
- Disk usage per filesystem
- Currently logged in users
- Last 5 successful logins
- All running systemd services

## Usage
```bash
chmod +x system_audit.sh    # one-time, makes the script executable
./system_audit.sh
```

Reports are saved to `reports/` with a timestamp, e.g. `audit_2026-04-21_23-07-39.txt`.

## Behavior
The script uses `set -euo pipefail` for fail-fast behavior.
Optional commands (`last`, `hostnamectl`) are checked with `command -v` before running 
— if missing, the section is skipped with a note rather than crashing the whole audit.

## Example output

===== SYSTEM AUDIT REPORT =====
Date: Tue Apr 21 22:48:47 CDT 2026
===== HOSTNAME & OS =====
Static hostname: thinkpad
Operating System: Ubuntu 25.10
Kernel: Linux 6.17.0-22-generic
Architecture: x86-64
===== CPU & Memory =====
CPU(s):                                  4
Model name:                              Intel(R) Core(TM) i5-6300U CPU @ 2.40GHz
total        used        free      shared  buff/cache   available
Mem:            30Gi       2.5Gi        17Gi       380Mi        10Gi        27Gi

## Skills demonstrated
- Bash scripting with strict mode (`set -euo pipefail`)
- Block output redirection
- Portable command detection with `command -v`
- Timestamped logging / report generation
- Linux system introspection (`hostnamectl`, `lscpu`, `free`, `df`, `systemctl`)

