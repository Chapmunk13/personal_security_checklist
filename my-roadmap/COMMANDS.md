# Quick Commands Reference

Essential commands for managing your security setup.

---

## Firewall (UFW)

```bash
# Check status
sudo ufw status verbose
sudo ufw status numbered

# Add rule
sudo ufw allow 8080/tcp
sudo ufw allow ssh

# Delete rule
sudo ufw delete [number]
sudo ufw delete allow 8080/tcp

# Reset (careful!)
sudo ufw reset

# Enable/disable
sudo ufw enable
sudo ufw disable

# Logging
sudo ufw logging on
sudo ufw logging off
```

---

## GPG

```bash
# List keys
gpg --list-keys
gpg --list-secret-keys --keyid-format=long

# Export public key
gpg --armor --export [KEY-ID]

# Sign a file
gpg --sign file.txt
gpg --clearsign file.txt

# Verify signature
gpg --verify file.txt.sig

# Git commits
git log --show-signature
git log --show-signature -1
git commit -S -m "Signed commit"

# Edit key
gpg --edit-key [KEY-ID]
```

---

## SSH

```bash
# Test connection
ssh -T git@github.com

# Generate new key
ssh-keygen -t ed25519 -C "your-email@example.com"

# Add passphrase to existing key
ssh-keygen -p -f ~/.ssh/id_ed25519

# List loaded keys
ssh-add -l

# Add key to agent
ssh-add ~/.ssh/id_ed25519

# Start ssh-agent
eval "$(ssh-agent -s)"

# Copy public key
cat ~/.ssh/id_ed25519.pub
```

---

## Backups (Restic)

```bash
# Run backup
~/.local/bin/backup-home.sh

# List snapshots
restic snapshots --repo /path/to/repo --password-file ~/.backup-password

# Restore latest
~/.local/bin/restore-backup.sh

# Check integrity
restic check --repo /path/to/repo --password-file ~/.backup-password

# View snapshot contents
restic ls latest --repo /path/to/repo --password-file ~/.backup-password

# Mount snapshot
mkdir /tmp/restic-mount
restic mount /tmp/restic-mount --repo /path/to/repo --password-file ~/.backup-password

# Forget old snapshots
restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 12 --prune

# Get stats
restic stats --repo /path/to/repo --password-file ~/.backup-password
```

---

## System Updates

```bash
# Check for updates
sudo apt update
apt list --upgradable

# Apply updates
sudo apt upgrade

# Apply all updates (including dist)
sudo apt dist-upgrade

# Auto-remove unused packages
sudo apt autoremove

# Check unattended-upgrades status
sudo systemctl status unattended-upgrades

# Force update check
sudo unattended-upgrade --debug

# View update history
cat /var/log/apt/history.log
cat /var/log/unattended-upgrades/unattended-upgrades.log

# Firmware updates
sudo fwupdmgr refresh
sudo fwupdmgr get-updates
sudo fwupdmgr update
```

---

## Fail2Ban

```bash
# Check status
sudo fail2ban-client status

# Check specific jail
sudo fail2ban-client status sshd

# Unban IP
sudo fail2ban-client set sshd unbanip 192.168.1.100

# Ban IP manually
sudo fail2ban-client set sshd banip 192.168.1.100

# View log
sudo tail -f /var/log/fail2ban.log

# Reload configuration
sudo fail2ban-client reload

# Restart
sudo systemctl restart fail2ban
```

---

## DNS / DNSCrypt

```bash
# Check DNS status
systemctl status dnscrypt-proxy

# Test resolution
dnscrypt-proxy -resolve cloudflare.com

# View current DNS
cat /etc/resolv.conf

# Test DNS
nslookup cloudflare.com
dig cloudflare.com

# Check for DNS leaks
curl -s https://www.dnsleaktest.com/

# Restart DNSCrypt
sudo systemctl restart dnscrypt-proxy
```

---

## Network Monitoring

```bash
# Show listening ports
sudo ss -tulpn
sudo netstat -tulpn
sudo lsof -i -P -n | grep LISTEN

# Network bandwidth (real-time)
sudo iftop
sudo nethogs

# Scan local network
nmap -sT 192.168.1.0/24

# Scan localhost
nmap -sT localhost

# Active connections
sudo ss -tunapl
watch -n 1 'sudo ss -tunapl'

# Check who's connected
w
who
last
```

---

## File System Security

```bash
# Check permissions
ls -la ~/.ssh
ls -la ~/.gnupg

# Fix SSH permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
chmod 600 ~/.ssh/config

# Secure delete
shred -vfz -n 10 file.txt

# Find SUID files
find / -perm -4000 -type f 2>/dev/null

# Find world-writable files
find / -type f -perm -0002 2>/dev/null

# Check disk usage
df -h
du -sh /*
ncdu /
```

---

## Security Monitoring

```bash
# Authentication failures
sudo grep "Failed password" /var/log/auth.log
sudo grep "Failed password" /var/log/auth.log | tail -20

# Successful logins
sudo grep "Accepted password" /var/log/auth.log

# Sudo usage
sudo grep "sudo" /var/log/auth.log

# System logs
sudo journalctl -xe
sudo journalctl -u ssh
sudo tail -f /var/log/syslog

# UFW logs
sudo grep UFW /var/log/syslog

# Check for rootkits (AIDE)
sudo aide --check

# List running services
systemctl list-units --type=service --state=running

# Check for listening services
sudo systemctl list-units --type=service --state=running | grep listen
```

---

## Git Security

```bash
# Check git config
git config --list
git config --global --list

# Sign commits
git commit -S -m "Signed commit"

# Verify commit signatures
git log --show-signature
git verify-commit HEAD

# Set up signing key
git config --global user.signingkey [KEY-ID]
git config --global commit.gpgsign true

# Check for secrets in commits
git log -p | grep -i "password\|secret\|api_key"

# Remove file from git history (careful!)
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch path/to/file" \
  --prune-empty --tag-name-filter cat -- --all
```

---

## Process Management

```bash
# List all processes
ps aux
htop

# Find process
ps aux | grep firefox
pgrep firefox

# Kill process
kill [PID]
killall firefox

# Check what files a process has open
lsof -p [PID]

# Check running services
systemctl list-units --type=service
```

---

## Browser Security

```bash
# Clear Firefox cache
rm -rf ~/.cache/mozilla/firefox/
rm -rf ~/.mozilla/firefox/*.default*/cache2/

# List Firefox extensions
ls ~/.mozilla/firefox/*.default-release/extensions/

# Check browser fingerprint
# Visit: https://amiunique.org
# Visit: https://panopticlick.eff.org

# Clear cookies
# Firefox: Ctrl+Shift+Del
# Chrome: Ctrl+Shift+Del
```

---

## Maintenance Scripts

```bash
# Weekly security check
cd ~/dev-ops/personal_security_checklist/my-roadmap
./phase-5-maintenance/weekly-security.sh

# Monthly audit
./phase-5-maintenance/monthly-security.sh

# Custom security check
sudo /usr/local/bin/check-updates.sh
```

---

## Emergency Commands

```bash
# Lock screen immediately
gnome-screensaver-command -l
# Or: Ctrl+Alt+L

# Kill all user processes (logout)
pkill -u $USER

# Emergency firewall lockdown
sudo ufw default deny incoming
sudo ufw default deny outgoing

# Disconnect network
sudo nmcli networking off

# View active connections
sudo ss -tunapl | grep ESTABLISHED

# Check for suspicious processes
ps aux --sort=-%cpu | head -10
ps aux --sort=-%mem | head -10

# Check cron jobs
crontab -l
sudo crontab -l
```

---

## System Information

```bash
# System info
uname -a
lsb_release -a
hostnamectl

# Disk info
lsblk
df -h
sudo fdisk -l

# Memory info
free -h
cat /proc/meminfo

# CPU info
lscpu
cat /proc/cpuinfo

# Network interfaces
ip addr
ifconfig

# Kernel version
uname -r

# Check for updates
apt list --upgradable
```

---

## Quick Security Checks

```bash
# All-in-one security status
echo "=== Firewall ===" && sudo ufw status && \
echo "=== Updates ===" && apt list --upgradable 2>/dev/null | wc -l && \
echo "=== Fail2Ban ===" && sudo fail2ban-client status && \
echo "=== Backups ===" && ls -lh ~/.backup.log && \
echo "=== Disk ===" && df -h / /home

# Check for common issues
sudo netstat -tulpn | grep LISTEN  # Open ports
sudo grep "Failed password" /var/log/auth.log | tail -10  # Auth failures
ps aux --sort=-%cpu | head -5  # Top CPU processes
```

---

**Tip**: Bookmark this file for quick access to commonly used commands!

**Last Updated**: 2025-11-06
