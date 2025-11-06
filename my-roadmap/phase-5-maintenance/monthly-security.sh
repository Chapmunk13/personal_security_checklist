#!/bin/bash
#
# Monthly Security Audit
# Run monthly for comprehensive security review
#

echo "=========================================="
echo "Monthly Security Audit - $(date)"
echo "=========================================="
echo ""

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

OUTPUT_FILE=~/security-audit-$(date +%Y%m%d).txt

echo "Generating security audit report..."
echo "Output will be saved to: $OUTPUT_FILE"
echo ""

{
    echo "=========================================="
    echo "MONTHLY SECURITY AUDIT"
    echo "Date: $(date)"
    echo "System: $(uname -a)"
    echo "=========================================="
    echo ""

    echo "1. INSTALLED PACKAGES"
    echo "----------------------------------------"
    dpkg -l | wc -l
    echo "total packages installed"
    echo ""

    echo "2. ENABLED SERVICES"
    echo "----------------------------------------"
    systemctl list-unit-files --type=service --state=enabled | head -20
    echo ""

    echo "3. NETWORK LISTENING PORTS"
    echo "----------------------------------------"
    sudo ss -tulpn | grep LISTEN
    echo ""

    echo "4. FIREWALL STATUS"
    echo "----------------------------------------"
    sudo ufw status verbose
    echo ""

    echo "5. GPG KEYS"
    echo "----------------------------------------"
    gpg --list-keys
    echo ""

    echo "6. SSH KEYS"
    echo "----------------------------------------"
    ls -la ~/.ssh/
    echo ""

    echo "7. FAIL2BAN STATUS"
    echo "----------------------------------------"
    if command -v fail2ban-client &> /dev/null; then
        sudo fail2ban-client status
    else
        echo "Fail2ban not installed"
    fi
    echo ""

    echo "8. RECENT AUTH FAILURES"
    echo "----------------------------------------"
    sudo grep "Failed" /var/log/auth.log | tail -20
    echo ""

    echo "9. DISK USAGE"
    echo "----------------------------------------"
    df -h
    echo ""

    echo "10. BACKUP STATUS"
    echo "----------------------------------------"
    if [ -f ~/.backup.log ]; then
        tail -20 ~/.backup.log
    else
        echo "No backup log found"
    fi
    echo ""

} | tee "$OUTPUT_FILE"

echo ""
echo "=========================================="
echo "MANUAL MONTHLY TASKS"
echo "=========================================="
echo "[ ] Test backup restore process"
echo "[ ] Rotate critical passwords (bank, email, etc.)"
echo "[ ] Review GitHub security advisories"
echo "[ ] Check for firmware updates: sudo fwupdmgr get-updates"
echo "[ ] Review network devices: nmap local network"
echo "[ ] Update security documentation"
echo "[ ] Review app permissions and browser extensions"
echo "[ ] Check for OS version updates"
echo "[ ] Review browser privacy settings"
echo "[ ] Verify 2FA on all critical accounts"
echo ""
echo -e "${GREEN}Monthly audit complete!${NC}"
echo "Report saved to: $OUTPUT_FILE"
