#!/bin/bash
#
# Phase 1.2: GPG Commit Signing Setup
# Priority: CRITICAL for dev-ops
# Time: 45 minutes
#
# This script configures GPG key signing for git commits
#

set -e  # Exit on error

echo "======================================"
echo "Phase 1.2: GPG Commit Signing"
echo "======================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "Step 1: Checking for existing GPG keys..."
if gpg --list-secret-keys --keyid-format=long 2>/dev/null | grep -q "sec"; then
    echo -e "${GREEN}✓ GPG keys found${NC}"
    echo ""
    gpg --list-secret-keys --keyid-format=long
    echo ""

    # Extract the key ID
    GPG_KEY_ID=$(gpg --list-secret-keys --keyid-format=long | grep "sec" | head -1 | sed 's/.*\/\([^ ]*\).*/\1/')
    echo "Using GPG key: $GPG_KEY_ID"
else
    echo -e "${YELLOW}No GPG keys found.${NC}"
    echo "Would you like to create a new GPG key? (y/n)"
    read -p "> " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Generating new GPG key..."
        echo "Please enter your details when prompted."
        echo "Recommended settings:"
        echo "  - Key type: ECC (sign and encrypt)"
        echo "  - Curve: Curve 25519"
        echo "  - Expiration: 2 years (you can extend it)"
        echo "  - Use a STRONG passphrase!"
        echo ""
        gpg --full-generate-key

        # Get the newly created key
        GPG_KEY_ID=$(gpg --list-secret-keys --keyid-format=long | grep "sec" | head -1 | sed 's/.*\/\([^ ]*\).*/\1/')
        echo -e "${GREEN}✓ GPG key created: $GPG_KEY_ID${NC}"
    else
        echo "Exiting. Please create a GPG key first."
        exit 1
    fi
fi

echo ""
echo "Step 2: Configuring git to use GPG signing..."

# Get current git user email
GIT_EMAIL=$(git config --global user.email 2>/dev/null || echo "")
if [ -z "$GIT_EMAIL" ]; then
    echo "Git email not configured. Please enter your git email:"
    read -p "> " GIT_EMAIL
    git config --global user.email "$GIT_EMAIL"
fi

# Configure git to use GPG key
git config --global user.signingkey "$GPG_KEY_ID"
git config --global commit.gpgsign true
git config --global tag.gpgSign true

echo -e "${GREEN}✓ Git configured for GPG signing${NC}"

echo ""
echo "Step 3: Exporting public key for GitHub..."
echo ""
echo "Copy the following public key and add it to GitHub:"
echo "GitHub → Settings → SSH and GPG keys → New GPG key"
echo ""
echo "========================================="
gpg --armor --export "$GPG_KEY_ID"
echo "========================================="
echo ""

read -p "Press Enter when you've added the key to GitHub..."

echo ""
echo "Step 4: Testing GPG signing..."
TEST_REPO="/tmp/gpg-test-$$"
git init "$TEST_REPO"
cd "$TEST_REPO"
git config user.email "$GIT_EMAIL"
git config user.name "$(git config --global user.name)"
git commit --allow-empty -m "Test GPG signing"

if git log --show-signature -1 2>&1 | grep -q "Good signature\|gpg:"; then
    echo -e "${GREEN}✓ GPG signing is working!${NC}"
else
    echo -e "${YELLOW}⚠ Could not verify signature. This might be normal on first run.${NC}"
fi

cd - > /dev/null
rm -rf "$TEST_REPO"

echo ""
echo "Step 5: Additional git security settings..."
git config --global transfer.fsckobjects true
git config --global fetch.fsckobjects true
git config --global receive.fsckObjects true
git config --global log.showSignature true
echo -e "${GREEN}✓ Git security settings applied${NC}"

echo ""
echo -e "${GREEN}======================================"
echo "GPG Commit Signing Complete!"
echo "======================================${NC}"
echo ""
echo "Your GPG key ID: $GPG_KEY_ID"
echo ""
echo "All future commits will be automatically signed."
echo ""
echo "Useful commands:"
echo "  - View keys: gpg --list-keys"
echo "  - View secret keys: gpg --list-secret-keys"
echo "  - Export public key: gpg --armor --export $GPG_KEY_ID"
echo "  - Sign a file: gpg --sign file.txt"
echo "  - Verify signature: git log --show-signature"
echo ""
echo "✓ Phase 1.2 Complete"
