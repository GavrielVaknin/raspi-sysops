# Backup script

## This script archieves, compress and uploads a a system image to the cloud

## It backs up all the system files besides the following :
# /proc, /sys, /tmp, /dev, /run.


## Requirements for this script are :
# AWS credentials, access keys, and other configurations.
# Use aws configure to place the access key, choose region, and output in json.
# Also make sure tar is installed

## Please run as sudo

## This script demonstrate the power of a well written script,
#  to serve us when the system is compromised.# 03 - System Backup Script

## What it does
Archives, compresses and uploads a full system backup to AWS S3.
Allows rollback to a previous known working state if something breaks.

## What it excludes
- /proc and /sys - virtual filesystems, recreated by kernel at boot
- /tmp - temporary files, not needed after reboot
- /dev - device files, recreated at boot
- /run - runtime data, recreated at boot

## Requirements
- AWS CLI installed (sudo dnf install awscli)
- IAM user with S3 access configured via aws configure
- tar installed (sudo dnf install tar)

## Usage
sudo ./backup.sh

## Skills demonstrated
- Bash scripting and error handling
- Linux filesystem knowledge
- AWS CLI and S3 integration
- IAM security and least privilege
- Automated cloud backup
