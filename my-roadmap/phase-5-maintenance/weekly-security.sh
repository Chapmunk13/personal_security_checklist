#!/bin/bash
#
# Weekly Security Maintenance
# Run every Monday or as needed
#

echo "=========================================="
echo "Weekly Security Check - $(date)"
echo "=========================================="
echo ""

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Function to check command success
check_command() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ $1${NC}"
    else
        echo -e "${RED}✗ $1 failed${NC}"
    fi
}

echo "1. System Updates Check"
echo "----------------------------------------"
sudo apt update -qq
UPDATES=$(apt list --upgradable 2>/dev/null | grep -c "upgradable")
if [ "$UPDATES" -gt 0 ]; then
    echo -e "${YELLOW}$UPDATES updates available${NC}"
    apt list --upgradable 2>/dev/null | head -10
else
    echo -e "${GREEN}✓ System is up to date${NC}"
fi

echo ""
echo "2. Firewall Status"
echo "----------------------------------------"
sudo ufw status | head -10
check_command "Firewall check"

echo ""
echo "3. Fail2Ban Status"
echo "----------------------------------------"
if command -v fail2ban-client &> /dev/null; then
    sudo fail2ban-client status | head -5
    check_command "Fail2ban check"
else
    echo -e "${YELLOW}Fail2ban not installed${NC}"
fi

echo ""
echo "4. Recent Authentication Failures"
echo "----------------------------------------"
sudo grep "Failed password" /var/log/auth.log 2>/dev/null | tail -5 || echo "No recent failures"

echo ""
echo "5. Disk Space"
echo "----------------------------------------"
df -h / /home | grep -v "tmpfs"
check_command "Disk space check"

echo ""
echo "6. SSH Keys Check"
echo "----------------------------------------"
if [ -f ~/.ssh/id_ed25519 ]; then
    echo -e "${GREEN}✓ SSH key exists${NC}"
    ls -l ~/.ssh/id_ed25519*
else
    echo -e "${YELLOW}⚠ No SSH key found${NC}"
fi

echo ""
echo "7. Backup Status"
echo "----------------------------------------"
if [ -f ~/.backup.log ]; then
    echo "Last backup:"
    tail -3 ~/.backup.log
else
    echo -e "${YELLOW}No backup log found${NC}"
fi

echo ""
echo "8. Running Services"
echo "----------------------------------------"
sudo ss -tulpn | grep LISTEN | wc -l
echo "listening services"

echo ""
echo "=========================================="
echo "MANUAL TASKS CHECKLIST"
echo "=========================================="
echo "[ ] Review browser extensions"
echo "[ ] Check Have I Been Pwned (https://haveibeenpwned.com)"
echo "[ ] Review GitHub security alerts"
echo "[ ] Update critical passwords if needed"
echo "[ ] Check SSH key usage on GitHub"
echo ""
echo "Weekly security check complete!"
