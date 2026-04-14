# 01 - System Audit Script

## What it does

Collects key system information and saves it to a timestamped report file.
Designed to be run on RHEL-based Linux Server.

## Information gathered

- Hostnames and OS details
- CPU model and core count
- Memory and disk swap usage
- Disk usage per filesystem
- Currently logged in users
- Last 5 login attempts
- All running systemd services

## Usage

- chmod +x system_audit.sh
./system_audit.sh

Reports are saved to the reports/ directory with a timestamp.

## Skills demonstrated

- Bash scripting
- Linux system commands
- File redirection and output formatting
- Automated report generation

