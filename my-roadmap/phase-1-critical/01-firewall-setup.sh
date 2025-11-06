#!/bin/bash
#
# Phase 1.1: Firewall Setup and Configuration
# Priority: CRITICAL
# Time: 30 minutes
#
# This script configures UFW (Uncomplicated Firewall) with secure defaults
#

set -e  # Exit on error

echo "======================================"
echo "Phase 1.1: Firewall Setup"
echo "======================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Error: This script must be run with sudo${NC}"
    exit 1
fi

echo "Step 1: Checking UFW installation..."
if ! command -v ufw &> /dev/null; then
    echo "Installing UFW..."
    apt update
    apt install -y ufw
else
    echo -e "${GREEN}✓ UFW is already installed${NC}"
fi

echo ""
echo "Step 2: Configuring default policies..."
ufw default deny incoming
ufw default allow outgoing
echo -e "${GREEN}✓ Default policies set${NC}"

echo ""
echo "Step 3: Allowing essential services..."

# SSH - Critical for remote access
# WARNING: If you're connected via SSH, this is essential!
read -p "Do you need SSH access? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    ufw allow ssh
    echo -e "${GREEN}✓ SSH access allowed${NC}"
fi

# HTTP/HTTPS - Useful for local development
read -p "Allow HTTP/HTTPS for local development servers? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    ufw allow 80/tcp
    ufw allow 443/tcp
    echo -e "${GREEN}✓ HTTP/HTTPS allowed${NC}"
fi

echo ""
echo "Step 4: Enabling UFW..."
ufw --force enable
echo -e "${GREEN}✓ UFW enabled${NC}"

echo ""
echo "Step 5: Enabling logging..."
ufw logging on
echo -e "${GREEN}✓ Logging enabled${NC}"

echo ""
echo "Step 6: Current firewall status..."
ufw status verbose

echo ""
echo -e "${GREEN}======================================"
echo "Firewall Setup Complete!"
echo "======================================${NC}"
echo ""
echo "Current rules:"
ufw status numbered
echo ""
echo "To manage firewall:"
echo "  - View status: sudo ufw status verbose"
echo "  - Allow port: sudo ufw allow <port>"
echo "  - Deny port: sudo ufw deny <port>"
echo "  - Delete rule: sudo ufw delete <rule-number>"
echo "  - Disable: sudo ufw disable"
echo ""
echo "✓ Phase 1.1 Complete"
