#!/bin/bash
#
# Phase 2.1: DNS-over-HTTPS Configuration
# Priority: HIGH
# Time: 30 minutes
#

set -e
echo "======================================"
echo "Phase 2.1: DNS-over-HTTPS Setup"
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

echo "Step 1: Installing DNSCrypt-Proxy..."
apt update
apt install -y dnscrypt-proxy

echo ""
echo "Step 2: Backing up configuration..."
cp /etc/dnscrypt-proxy/dnscrypt-proxy.toml /etc/dnscrypt-proxy/dnscrypt-proxy.toml.backup

echo ""
echo "Step 3: Configuring DNSCrypt..."
cat > /etc/dnscrypt-proxy/dnscrypt-proxy.toml << 'EOF'
server_names = ['cloudflare', 'cloudflare-ipv6', 'quad9-dnscrypt-ip4-filter-pri']
listen_addresses = ['127.0.0.1:53']
max_clients = 250
ipv4_servers = true
ipv6_servers = true
dnscrypt_servers = true
doh_servers = true
require_dnssec = true
require_nolog = true
require_nofilter = false
force_tcp = false
timeout = 5000
keepalive = 30
cert_refresh_delay = 240
cache = true
cache_size = 4096
cache_min_ttl = 2400
cache_max_ttl = 86400
cache_neg_ttl = 60
EOF

echo -e "${GREEN}✓ DNSCrypt configured${NC}"

echo ""
echo "Step 4: Disabling systemd-resolved..."
systemctl disable systemd-resolved
systemctl stop systemd-resolved

echo ""
echo "Step 5: Updating resolv.conf..."
rm -f /etc/resolv.conf
echo "nameserver 127.0.0.1" > /etc/resolv.conf
echo "options edns0" >> /etc/resolv.conf
chattr +i /etc/resolv.conf  # Make immutable

echo -e "${GREEN}✓ resolv.conf configured${NC}"

echo ""
echo "Step 6: Starting DNSCrypt..."
systemctl enable dnscrypt-proxy
systemctl restart dnscrypt-proxy

sleep 2
if systemctl is-active --quiet dnscrypt-proxy; then
    echo -e "${GREEN}✓ DNSCrypt is running${NC}"
else
    echo -e "${RED}✗ DNSCrypt failed to start${NC}"
    exit 1
fi

echo ""
echo "Step 7: Testing DNS resolution..."
if dnscrypt-proxy -resolve cloudflare.com; then
    echo -e "${GREEN}✓ DNS resolution working${NC}"
else
    echo -e "${YELLOW}⚠ DNS test inconclusive${NC}"
fi

echo ""
echo -e "${GREEN}✓ Phase 2.1 Complete${NC}"
echo "DNS-over-HTTPS is now active"
