#!/bin/bash
#
# Phase 2.2: Fail2Ban Installation
# Priority: MEDIUM-HIGH
# Time: 45 minutes
#

set -e
echo "======================================"
echo "Phase 2.2: Fail2Ban Setup"
echo "======================================"
echo ""

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Error: This script must be run with sudo${NC}"
    exit 1
fi

echo "Step 1: Installing fail2ban..."
apt update
apt install -y fail2ban

echo ""
echo "Step 2: Creating local configuration..."
cat > /etc/fail2ban/jail.local << EOF
[DEFAULT]
# Ban settings
bantime = 1h
findtime = 10m
maxretry = 5

# Email alerts (configure if you have mail setup)
destemail = root@localhost
sender = fail2ban@localhost
mta = sendmail

# Action
action = %(action_mwl)s

[sshd]
enabled = true
port = ssh
logpath = %(sshd_log)s
backend = %(sshd_backend)s
maxretry = 3
bantime = 24h

[sshd-ddos]
enabled = true
port = ssh
logpath = %(sshd_log)s
maxretry = 2
EOF

echo -e "${GREEN}✓ Configuration created${NC}"

echo ""
echo "Step 3: Starting fail2ban..."
systemctl enable fail2ban
systemctl restart fail2ban

echo ""
echo "Step 4: Checking status..."
sleep 2
fail2ban-client status

echo ""
echo -e "${GREEN}✓ Phase 2.2 Complete${NC}"
echo ""
echo "Useful commands:"
echo "  - Status: sudo fail2ban-client status"
echo "  - Check jail: sudo fail2ban-client status sshd"
echo "  - Unban IP: sudo fail2ban-client set sshd unbanip <IP>"
echo "  - View log: sudo tail -f /var/log/fail2ban.log"
