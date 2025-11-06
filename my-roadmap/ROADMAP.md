# Personal Security Roadmap for Dev-Ops
# Comprehensive Implementation Guide

> **Based on**: [Personal Security Checklist](https://github.com/Lissy93/personal-security-checklist)
> **Tailored for**: Linux Dev-Ops Environment (Ubuntu 24.04)
> **Priority**: Network Security & System Hardening
> **Approach**: Critical-first implementation

---

## Table of Contents

1. [Overview](#overview)
2. [Current Security Posture](#current-security-posture)
3. [Phase 1: Critical Security Gaps (48 hours)](#phase-1-critical-security-gaps)
4. [Phase 2: Network Security (Week 1)](#phase-2-network-security)
5. [Phase 3: System Hardening (Week 2)](#phase-3-system-hardening)
6. [Phase 4: Advanced Protections (Weeks 3-4)](#phase-4-advanced-protections)
7. [Phase 5: Ongoing Maintenance](#phase-5-ongoing-maintenance)
8. [Quick Reference](#quick-reference)
9. [Emergency Procedures](#emergency-procedures)

---

## Overview

This roadmap provides a systematic approach to securing your dev-ops environment based on the comprehensive Personal Security Checklist. It's organized into 5 phases, progressing from critical immediate actions to ongoing maintenance.

### Time Investment

- **Initial Setup**: ~20-25 hours over 4 weeks
- **Ongoing Maintenance**: ~3-4 hours/month
- **Phase 1 (Critical)**: 3.5 hours
- **Phase 2 (Network)**: 3.25 hours
- **Phase 3 (System)**: 5.5 hours
- **Phase 4 (Advanced)**: 8-12 hours

### Priority Levels

- ⚠️ **CRITICAL**: Must do immediately - security vulnerabilities
- 🔴 **HIGH**: Do within week 1 - important protections
- 🟡 **MEDIUM**: Do within month 1 - recommended hardening
- 🟢 **LOW**: Optional enhancements - nice to have

---

## Current Security Posture

### ✅ Strengths

- Password manager configured (pass/password-store)
- SSH keys generated (Ed25519) with correct permissions
- GPG key exists (Ed25519)
- UFW firewall service enabled
- Browsers up-to-date (Firefox, Chrome)
- Backup tools installed

### ⚠️ Critical Gaps Identified

1. **NO DISK ENCRYPTION** - /home and / partitions unencrypted
2. **NO GPG COMMIT SIGNING** - Git commits not signed
3. **NO SSH HARDENING** - Missing SSH config, no passphrase verification
4. **FIREWALL NOT CONFIGURED** - UFW enabled but rules not verified
5. **NO BACKUP STRATEGY** - Tools installed but no active backups
6. **DEFAULT DNS** - No DoH/DoT configured
7. **NO VPN** - No VPN client installed
8. **NO FAIL2BAN** - No intrusion prevention
9. **BROWSER NOT HARDENED** - No security extensions
10. **UPDATE STATUS UNKNOWN** - Automatic updates not verified

---

## Phase 1: Critical Security Gaps

**Timeline**: 48 hours
**Total Time**: ~3.5 hours
**Priority**: ⚠️ CRITICAL

### 1.1 Verify and Configure Firewall (30 min) ⚠️

**Script**: `phase-1-critical/01-firewall-setup.sh`

```bash
cd ~/dev-ops/personal_security_checklist/my-roadmap
sudo ./phase-1-critical/01-firewall-setup.sh
```

**What it does**:
- Configures UFW with secure defaults (deny incoming, allow outgoing)
- Sets up essential service rules (SSH, HTTP/HTTPS if needed)
- Enables logging for security monitoring
- Activates firewall protection

**Manual verification**:
```bash
sudo ufw status verbose
sudo ufw status numbered
```

**Checklist items addressed**:
- [x] Use a Firewall (Networking)
- [x] Configure firewall rules (Personal Computers)

---

### 1.2 Enable GPG Commit Signing (45 min) ⚠️

**Script**: `phase-1-critical/02-gpg-signing.sh`

```bash
./phase-1-critical/02-gpg-signing.sh
```

**What it does**:
- Configures git to automatically sign commits with GPG
- Sets up git security best practices
- Exports public key for GitHub
- Tests GPG signing functionality

**Post-setup**:
1. Add GPG public key to GitHub (Settings → SSH and GPG keys)
2. Verify signature appears on commits: `git log --show-signature`

**Checklist items addressed**:
- [x] Verify code authenticity (Authentication)
- [x] Enable commit signing (Personal Computers)

---

### 1.3 Harden SSH Configuration (30 min) ⚠️

**Script**: `phase-1-critical/03-ssh-hardening.sh`

```bash
./phase-1-critical/03-ssh-hardening.sh
```

**What it does**:
- Creates hardened SSH client configuration
- Sets correct permissions on SSH files (700/.ssh, 600/private key)
- Configures strong ciphers and key exchange algorithms
- Adds passphrase to SSH key if missing
- Sets up SSH agent

**Manual verification**:
```bash
ls -la ~/.ssh/
cat ~/.ssh/config
ssh -T git@github.com
```

**Checklist items addressed**:
- [x] Secure SSH Access (Personal Computers)
- [x] Use strong authentication (Authentication)

---

### 1.4 Implement Automated Backup Strategy (1 hour) ⚠️

**Script**: `phase-1-critical/04-backup-setup.sh`

```bash
./phase-1-critical/04-backup-setup.sh
```

**What it does**:
- Installs and configures restic (encrypted backups)
- Creates automated backup script for critical directories
- Sets up daily cron job for automatic backups
- Generates restore script for disaster recovery
- Backs up: dev-ops, .ssh, .gnupg, Documents, .password-store

**Important**:
- Save backup password in password manager!
- Test restore monthly

**Manual commands**:
```bash
# Run backup manually
~/.local/bin/backup-home.sh

# List backups
restic snapshots --repo /path/to/repo --password-file ~/.backup-password

# Restore
~/.local/bin/restore-backup.sh
```

**Checklist items addressed**:
- [x] Backup Important Data (Personal Computers)
- [x] Use encrypted backups (Personal Computers)

---

### 1.5 Verify System Updates (15 min) 🔴

**Script**: `phase-1-critical/05-system-updates.sh`

```bash
sudo ./phase-1-critical/05-system-updates.sh
```

**What it does**:
- Enables automatic security updates
- Configures unattended-upgrades
- Checks for and applies system updates
- Checks for firmware updates
- Sets up automatic update timers

**Manual verification**:
```bash
sudo /usr/local/bin/check-updates.sh
systemctl status unattended-upgrades
```

**Checklist items addressed**:
- [x] Keep System Up-to-date (Personal Computers)
- [x] Enable automatic security updates

---

### Phase 1 Completion Checklist

After completing Phase 1, verify:

- [ ] Firewall is active with rules configured
- [ ] GPG signing works for git commits
- [ ] SSH key has passphrase and hardened config
- [ ] First backup completed successfully
- [ ] Automatic updates enabled
- [ ] All Phase 1 scripts executed without errors

**Test commands**:
```bash
# Firewall
sudo ufw status verbose

# GPG
git commit --allow-empty -m "Test" && git log --show-signature -1

# SSH
ssh -T git@github.com

# Backup
restic snapshots --repo [your-repo] --password-file ~/.backup-password

# Updates
sudo systemctl status unattended-upgrades
```

---

## Phase 2: Network Security

**Timeline**: Week 1 (7 days)
**Total Time**: ~3.25 hours
**Priority**: 🔴 HIGH

### 2.1 Configure DNS-over-HTTPS (30 min) 🔴

**Script**: `phase-2-network/01-dns-over-https.sh`

```bash
sudo ./phase-2-network/01-dns-over-https.sh
```

**What it does**:
- Installs DNSCrypt-Proxy
- Configures encrypted DNS (CloudFlare, Quad9)
- Disables systemd-resolved
- Requires DNSSEC validation
- Prevents DNS leaks and ISP tracking

**Checklist items addressed**:
- [x] Use DNS-over-HTTPS (Web Browsing)
- [x] Secure DNS (Networks)
- [x] Protect against DNS leaks (Networks)

---

### 2.2 Install and Configure VPN (1 hour) 🔴

**Manual setup required** - VPN provider dependent

**Recommended VPN providers for Linux**:
1. **Mullvad** - Best privacy (no email required)
2. **IVPN** - Strong privacy policies
3. **ProtonVPN** - Good free tier

**Installation (example - Mullvad)**:
```bash
# Download from mullvad.net
sudo apt install ./mullvad-vpn*.deb

# Or use WireGuard with any provider
sudo apt install wireguard wireguard-tools
```

**Configuration**:
- Set up kill switch (blocks traffic if VPN drops)
- Configure split tunneling for local network
- Enable on public WiFi automatically

**Checklist items addressed**:
- [x] Use a VPN (Networks)
- [x] Use secure VPN protocol (Networks)

---

### 2.3 Install and Configure Fail2Ban (45 min) 🔴

**Script**: `phase-2-network/02-fail2ban-setup.sh`

```bash
sudo ./phase-2-network/02-fail2ban-setup.sh
```

**What it does**:
- Installs fail2ban intrusion prevention
- Configures SSH brute-force protection
- Sets up automatic IP banning
- Enables logging and monitoring

**Manual commands**:
```bash
# Check status
sudo fail2ban-client status
sudo fail2ban-client status sshd

# Unban IP if needed
sudo fail2ban-client set sshd unbanip <IP>
```

**Checklist items addressed**:
- [x] Prevent brute force attacks (Personal Computers)
- [x] Network intrusion prevention (Networks)

---

### 2.4 Network Monitoring Setup (1 hour) 🟡

**Tools to install**:
```bash
sudo apt install -y iftop nethogs nmap
```

**Usage**:
- `iftop` - Real-time bandwidth monitoring
- `nethogs` - Per-process network usage
- `nmap` - Network scanning and discovery

**Create monitoring routine**:
```bash
# Weekly network scan
nmap -sT localhost > ~/network-scan-$(date +%Y%m%d).txt

# Check listening ports
sudo ss -tulpn | grep LISTEN

# Monitor active connections
sudo netstat -tunapl
```

**Checklist items addressed**:
- [x] Network security awareness (Networks)
- [x] Close unused open ports (Personal Computers)

---

### Phase 2 Completion Checklist

- [ ] DNS-over-HTTPS configured and working
- [ ] VPN installed and tested
- [ ] Fail2Ban active and monitoring
- [ ] Network monitoring tools installed
- [ ] No unexpected open ports

---

## Phase 3: System Hardening

**Timeline**: Week 2 (14 days)
**Total Time**: ~5.5 hours
**Priority**: 🟡 MEDIUM

### 3.1 Browser Security Hardening (1 hour) 🟡

**Firefox Extensions** (Essential):
1. **uBlock Origin** - Ad/tracker blocking
2. **Privacy Badger** - Automatic tracker blocking
3. **Multi-Account Containers** - Compartmentalization
4. **Bitwarden** - Password manager integration

**Firefox Configuration** (`about:config`):
```
privacy.trackingprotection.enabled = true
privacy.firstparty.isolate = true
privacy.resistFingerprinting = true
network.cookie.cookieBehavior = 1
network.dns.disablePrefetch = true
geo.enabled = false
```

**Create separate browser profiles**:
```bash
firefox -ProfileManager
```

Profiles:
- Personal (default)
- Work (dev-ops)
- Banking (isolated)

**Checklist items addressed**:
- [x] Use Privacy-Respecting Browser (Web Browsing)
- [x] Block Ads and Trackers (Web Browsing)
- [x] Use Multi-Session Containers (Web Browsing)

---

### 3.2 Application Security Review (2 hours) 🟡

**Tasks**:

1. **Review installed packages**:
```bash
dpkg -l > ~/installed-packages-$(date +%Y%m%d).txt
```

2. **Remove unnecessary packages**:
```bash
sudo apt autoremove -y
sudo apt autopurge
```

3. **Review startup services**:
```bash
systemctl list-unit-files --type=service --state=enabled > ~/enabled-services.txt
```

4. **Disable unnecessary services** (examples):
```bash
# If you don't use Bluetooth
sudo systemctl disable bluetooth

# If you don't use network printing
sudo systemctl disable cups-browsed
```

**Checklist items addressed**:
- [x] Review Installed Apps (Personal Computers)
- [x] Minimize attack surface

---

### 3.3 File System Security (2 hours) 🟡

**Set proper permissions**:
```bash
chmod 700 ~/.ssh ~/.gnupg
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
chmod 600 ~/.ssh/config
```

**Create encrypted container** for sensitive files:
```bash
# Install tools
sudo apt install -y cryptsetup

# Create 1GB encrypted container
dd if=/dev/zero of=~/secure-vault.img bs=1M count=1024
sudo cryptsetup luksFormat ~/secure-vault.img
sudo cryptsetup luksOpen ~/secure-vault.img secure-vault
sudo mkfs.ext4 /dev/mapper/secure-vault
```

**Mount/unmount scripts** provided in scripts directory.

**Checklist items addressed**:
- [x] Store personal data securely (Human Aspect)
- [x] Partial disk encryption (Personal Computers)

---

### 3.4 Git Security Hardening (30 min) 🔴

**Enhanced git configuration**:
```bash
# Verify transferred objects
git config --global transfer.fsckobjects true
git config --global fetch.fsckobjects true
git config --global receive.fsckObjects true

# Show signatures by default
git config --global log.showSignature true

# Use SSH instead of HTTPS
git config --global url."git@github.com:".insteadOf "https://github.com/"

# Prevent accidental pushes
git config --global push.default simple
git config --global push.followTags true
```

**Set up pre-commit hooks** (checks for secrets):
```bash
mkdir -p ~/.git-templates/hooks
# Create pre-commit hook (see script)
git config --global init.templatedir '~/.git-templates'
```

**Checklist items addressed**:
- [x] Secure development workflow
- [x] Prevent credential leaks

---

### Phase 3 Completion Checklist

- [ ] Browser hardened with extensions
- [ ] Unnecessary apps/services removed
- [ ] File permissions correctly set
- [ ] Encrypted container created
- [ ] Git security hardening applied
- [ ] Pre-commit hooks working

---

## Phase 4: Advanced Protections

**Timeline**: Weeks 3-4 (30 days)
**Total Time**: ~8-12 hours
**Priority**: 🟡 MEDIUM / 🟢 LOW

### 4.1 Full Disk Encryption Planning ⚠️ CRITICAL (but complex)

**⚠️ WARNING**: This requires backing up all data and reinstalling Ubuntu.

**Why it's critical**: Without full disk encryption, anyone with physical access to your machine can read all your data, including:
- SSH private keys
- GPG keys
- Password databases
- Source code
- Personal files

**Time required**: 4-8 hours (full reinstall)

**Steps**:

1. **Complete ALL backups** from Phase 1.4
2. **Test restore** to ensure backups work
3. **Document installed packages**:
   ```bash
   dpkg --get-selections > packages.txt
   ```
4. **Export configurations**
5. **Create Ubuntu installation USB** with LUKS encryption option
6. **Reinstall Ubuntu** with encryption enabled
7. **Restore from backups**

**Alternative** (Partial solution):
- Encrypt /home only (see Phase 3.3)
- Use encrypted containers for sensitive data
- **Note**: This leaves system files unencrypted

**Recommendation**: Schedule for a weekend when you have time.

---

### 4.2 Implement Security Monitoring (2 hours) 🟡

**Install AIDE** (File integrity monitoring):
```bash
sudo apt install -y aide
sudo aideinit
```

**Weekly security checks**:
```bash
sudo aide --check
```

**Log monitoring**:
```bash
# Authentication failures
sudo grep "Failed password" /var/log/auth.log

# Firewall logs
sudo grep UFW /var/log/syslog

# Fail2ban activity
sudo tail -f /var/log/fail2ban.log
```

**Checklist items addressed**:
- [x] Check for rootkits (Personal Computers)
- [x] Security monitoring and awareness

---

### 4.3 Enhanced Authentication (1 hour) 🟡

**Configure PAM** for stronger passwords:
```bash
sudo apt install -y libpam-pwquality
sudo nano /etc/security/pwquality.conf
```

Set:
```
minlen = 16
dcredit = -1
ucredit = -1
lcredit = -1
ocredit = -1
```

**Enable automatic screen lock**:
```bash
gsettings set org.gnome.desktop.session idle-delay 300  # 5 min
gsettings set org.gnome.desktop.screensaver lock-enabled true
gsettings set org.gnome.desktop.screensaver lock-delay 0
```

**Checklist items addressed**:
- [x] Activate screen-lock (Personal Computers)
- [x] Strong password policies (Authentication)

---

### 4.4 Privacy Tools Installation (1 hour) 🟢

**Install privacy tools**:
```bash
sudo apt install -y tor torsocks mat2 bleachbit
```

**Tools**:
- **Tor Browser** - Anonymous browsing
- **mat2** - Metadata removal from files
- **bleachbit** - Secure file deletion

**Usage**:
```bash
# Remove metadata before sharing files
mat2 document.pdf

# Secure file deletion
shred -vfz -n 10 sensitive-file.txt
```

**Checklist items addressed**:
- [x] Use Tor for sensitive browsing
- [x] Remove metadata from files

---

### Phase 4 Completion Checklist

- [ ] Full disk encryption planned (or completed)
- [ ] Security monitoring tools installed
- [ ] Enhanced authentication configured
- [ ] Privacy tools installed and tested
- [ ] Disaster recovery plan documented

---

## Phase 5: Ongoing Maintenance

**Timeline**: Continuous
**Priority**: 🔴 HIGH (for maintaining security)

### Weekly Security Tasks (30 min/week)

**Script**: `phase-5-maintenance/weekly-security.sh`

```bash
cd ~/dev-ops/personal_security_checklist/my-roadmap
./phase-5-maintenance/weekly-security.sh
```

**Tasks automated**:
- Check for system updates
- Verify firewall status
- Check fail2ban logs
- Review authentication failures
- Check disk space
- Verify backup completion
- Review running services

**Manual tasks**:
- [ ] Review browser extensions
- [ ] Check Have I Been Pwned
- [ ] Review GitHub security alerts
- [ ] Update critical passwords if needed
- [ ] Check SSH key usage

---

### Monthly Security Tasks (2 hours/month)

**Script**: `phase-5-maintenance/monthly-security.sh`

```bash
./phase-5-maintenance/monthly-security.sh
```

**Tasks automated**:
- Comprehensive system audit
- Package review
- Service review
- Network port scan
- GPG/SSH key verification
- Backup verification

**Manual tasks**:
- [ ] Test backup restore
- [ ] Rotate critical passwords
- [ ] Review GitHub security advisories
- [ ] Check for firmware updates
- [ ] Scan local network for unauthorized devices
- [ ] Update security documentation
- [ ] Review app permissions
- [ ] Browser privacy audit
- [ ] Verify 2FA on critical accounts

---

### Quarterly Deep Dive (4 hours/quarter)

**Tasks**:
1. Full security review and threat model reassessment
2. Encryption audit (verify all encryption working)
3. Disaster recovery test (full restore)
4. Network security audit (comprehensive scan)
5. Password audit (review all passwords)
6. 2FA audit (ensure on all critical accounts)
7. Privacy review (check for new threats)
8. Tool updates (review new security tools)
9. Documentation update
10. Security training (learn about new threats)

---

## Quick Reference

### Daily Commands

```bash
# Check firewall
sudo ufw status

# Check for updates
sudo apt update && apt list --upgradable

# Check fail2ban
sudo fail2ban-client status

# Run backup
~/.local/bin/backup-home.sh
```

### Weekly Commands

```bash
# Run weekly security check
./phase-5-maintenance/weekly-security.sh

# Update system
sudo apt update && sudo apt upgrade

# Check logs
sudo tail -100 /var/log/auth.log
```

### Monthly Commands

```bash
# Run monthly audit
./phase-5-maintenance/monthly-security.sh

# Test backup restore
~/.local/bin/restore-backup.sh

# Check firmware
sudo fwupdmgr get-updates
```

---

## Emergency Procedures

### If SSH Key Compromised

1. Immediately revoke key from GitHub/servers
2. Generate new SSH key: `ssh-keygen -t ed25519`
3. Update all servers/services with new key
4. Review access logs for unauthorized access
5. Change passwords on affected accounts

### If GPG Key Compromised

1. Revoke key: `gpg --gen-revoke [KEY-ID]`
2. Upload revocation certificate
3. Generate new GPG key
4. Re-sign all commits if needed
5. Update GitHub/GitLab with new key

### If System Compromised

1. Disconnect from network immediately
2. Boot from live USB
3. Mount encrypted backup drive
4. Restore from last known good backup
5. Analyze compromise vector
6. Rebuild system if necessary
7. Rotate ALL credentials

### If Backup Lost/Corrupted

1. Stop all backup jobs
2. Verify integrity: `restic check`
3. List available snapshots: `restic snapshots`
4. Restore from last good snapshot
5. Review backup configuration
6. Test restore process
7. Implement off-site backup

---

## Resources

### Documentation
- Personal Security Checklist: https://github.com/Lissy93/personal-security-checklist
- Awesome Privacy: https://github.com/lissy93/awesome-privacy
- Ubuntu Security: https://ubuntu.com/security
- Linux Hardening: https://madaidans-insecurities.github.io/guides/linux-hardening.html

### Tools
- Restic: https://restic.readthedocs.io/
- Fail2Ban: https://www.fail2ban.org/
- GPG: https://gnupg.org/documentation/
- SSH: https://www.ssh.com/academy/

### Learning
- OWASP Top 10: https://owasp.org/www-project-top-ten/
- CIS Benchmarks: https://www.cisecurity.org/cis-benchmarks/
- NIST Cybersecurity Framework: https://www.nist.gov/cyberframework

---

## Progress Tracking

Use `PROGRESS.md` to track your completion status through each phase.

---

**Last Updated**: 2025-11-06
**Version**: 1.0
**Maintainer**: Generated from Personal Security Checklist
