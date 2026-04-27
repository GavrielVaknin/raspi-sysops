# Single-file restore drill

A documented procedure for recovering an individual file from a backup created by [`scripts/03-backup/backup.sh`](../scripts/03-backup/backup.sh).

Tested on AlmaLinux 9 with SELinux in enforcing mode, restoring `/etc/hostname` from a real S3 backup.

## Scenario

A user (or a bad script) has corrupted or deleted a system file.
Re-extracting the entire 1.2 GB archive is wasteful.
We pull just the file we need, verify, and restore it with correct permissions and SELinux context.

## Procedure

### 1. Set up a sandbox

Never extract an archive into a directory where the extracted files might overwrite something live.

```bash
mkdir ~/restore-drill
cd ~/restore-drill
```

### 2. Download the archive and its hash

```bash
aws s3 ls s3://<S3-BUCKET-NAME>/
aws s3 cp s3://<S3-BUCKET-NAME>/<filename>.tar.gz .
aws s3 cp s3://<S3-BUCKET-NAME>/<filename>.tar.gz.sha256 .
```

### 3. Verify integrity before trusting any contents

```bash
sha256sum -c <filename>.tar.gz.sha256
```

Must print `OK`. If `FAILED`, stop — the archive is corrupt.

### 4. Locate the target file inside the archive

`tar -tzf` lists archive contents without extracting. Pipe to `grep` to find the file you need.

```bash
tar -tzf <filename>.tar.gz | grep "etc/hostname"
```

Note: paths inside the archive have no leading `/` — `tar` strips it during creation (you'll see this in the script's `Removing leading '/' from member names` warning).

### 5. Extract only the target file

`tar -xzf` accepts specific paths to extract. Other files stay packed inside the archive.

```bash
tar -xzf <filename>.tar.gz etc/hostname
```

This creates `./etc/hostname` in the sandbox. The directory structure is preserved.

### 6. Inspect before restoring

```bash
ls -la etc/hostname
cat etc/hostname
```

Confirm the contents match what you expect. Never restore a file you haven't read.

### 7. Backup the current file (always reversible)

```bash
sudo cp -p /etc/hostname /etc/hostname.bak
```

`-p` preserves mode, ownership, and timestamps. Critical for system files.

### 8. Restore the file

```bash
sudo cp -p etc/hostname /etc/hostname
```

### 9. Restore SELinux context

`cp` from a user's home directory leaves the new file with the user's SELinux context, not the system context.
SELinux will block reads of system files with wrong contexts. `restorecon` fixes this by reapplying the policy-defined context.

```bash
ls -lZ /etc/hostname               # before — likely shows wrong context
sudo restorecon -v /etc/hostname   # fixes it
ls -lZ /etc/hostname               # after — correct context
```

### 10. Verify the system reads the file correctly

```bash
hostnamectl
hostname
```

Both should report the expected hostname. If they don't, SELinux or permissions are still wrong.

### 11. Clean up

```bash
sudo rm /etc/hostname.bak
cd ~
rm -rf ~/restore-drill
```

## Notes for non-RHEL distros

On Debian/Ubuntu, AppArmor is the default mandatory access control system instead of SELinux.
The `restorecon` step is unnecessary, but `cp -p` (or `install` with explicit ownership) still matters. Check `aa-status` to see AppArmor profiles.

