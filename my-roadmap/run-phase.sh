#!/bin/bash
#
# Security Roadmap - Phase Runner
# Helps run phases systematically
#

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

show_menu() {
    clear
    echo -e "${BLUE}=========================================="
    echo "   Security Roadmap - Phase Runner"
    echo -e "==========================================${NC}"
    echo ""
    echo "Select a phase to run:"
    echo ""
    echo -e "${RED}⚠️  Phase 1: Critical Security Gaps${NC}"
    echo "    1. Firewall Setup (30 min) - sudo required"
    echo "    2. GPG Commit Signing (45 min)"
    echo "    3. SSH Hardening (30 min)"
    echo "    4. Backup Setup (1 hour)"
    echo "    5. System Updates (15 min) - sudo required"
    echo ""
    echo -e "${YELLOW}🔴 Phase 2: Network Security${NC}"
    echo "    6. DNS-over-HTTPS (30 min) - sudo required"
    echo "    7. Fail2Ban Setup (45 min) - sudo required"
    echo ""
    echo -e "${GREEN}📋 Maintenance${NC}"
    echo "    8. Weekly Security Check"
    echo "    9. Monthly Security Audit"
    echo ""
    echo -e "${BLUE}📊 Status & Info${NC}"
    echo "    10. View Progress"
    echo "    11. View Roadmap"
    echo "    12. View Commands Reference"
    echo ""
    echo "    0. Exit"
    echo ""
}

run_script() {
    local script_path="$1"
    local script_name="$2"
    local needs_sudo="$3"

    echo ""
    echo -e "${BLUE}=========================================="
    echo "Running: $script_name"
    echo -e "==========================================${NC}"
    echo ""

    if [ ! -f "$script_path" ]; then
        echo -e "${RED}Error: Script not found: $script_path${NC}"
        read -p "Press Enter to continue..."
        return 1
    fi

    if [ ! -x "$script_path" ]; then
        chmod +x "$script_path"
    fi

    echo "About to run: $script_path"
    echo ""
    read -p "Continue? (y/n) " -n 1 -r
    echo

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipped."
        read -p "Press Enter to continue..."
        return 0
    fi

    if [ "$needs_sudo" = "true" ]; then
        sudo "$script_path"
    else
        "$script_path"
    fi

    local exit_code=$?

    echo ""
    if [ $exit_code -eq 0 ]; then
        echo -e "${GREEN}✓ Script completed successfully${NC}"
    else
        echo -e "${RED}✗ Script failed with exit code: $exit_code${NC}"
    fi

    echo ""
    read -p "Press Enter to continue..."
}

view_file() {
    local file_path="$1"
    local file_name="$2"

    clear
    echo -e "${BLUE}=========================================="
    echo "Viewing: $file_name"
    echo -e "==========================================${NC}"
    echo ""

    if [ ! -f "$file_path" ]; then
        echo -e "${RED}Error: File not found: $file_path${NC}"
    else
        less "$file_path"
    fi

    echo ""
    read -p "Press Enter to continue..."
}

main() {
    while true; do
        show_menu

        read -p "Enter your choice: " choice

        case $choice in
            1)
                run_script "$SCRIPT_DIR/phase-1-critical/01-firewall-setup.sh" "Firewall Setup" "true"
                ;;
            2)
                run_script "$SCRIPT_DIR/phase-1-critical/02-gpg-signing.sh" "GPG Commit Signing" "false"
                ;;
            3)
                run_script "$SCRIPT_DIR/phase-1-critical/03-ssh-hardening.sh" "SSH Hardening" "false"
                ;;
            4)
                run_script "$SCRIPT_DIR/phase-1-critical/04-backup-setup.sh" "Backup Setup" "false"
                ;;
            5)
                run_script "$SCRIPT_DIR/phase-1-critical/05-system-updates.sh" "System Updates" "true"
                ;;
            6)
                run_script "$SCRIPT_DIR/phase-2-network/01-dns-over-https.sh" "DNS-over-HTTPS" "true"
                ;;
            7)
                run_script "$SCRIPT_DIR/phase-2-network/02-fail2ban-setup.sh" "Fail2Ban Setup" "true"
                ;;
            8)
                run_script "$SCRIPT_DIR/phase-5-maintenance/weekly-security.sh" "Weekly Security Check" "false"
                ;;
            9)
                run_script "$SCRIPT_DIR/phase-5-maintenance/monthly-security.sh" "Monthly Security Audit" "false"
                ;;
            10)
                view_file "$SCRIPT_DIR/PROGRESS.md" "Progress Tracker"
                ;;
            11)
                view_file "$SCRIPT_DIR/ROADMAP.md" "Complete Roadmap"
                ;;
            12)
                view_file "$SCRIPT_DIR/COMMANDS.md" "Commands Reference"
                ;;
            0)
                echo ""
                echo "Exiting. Stay secure!"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid choice. Please try again.${NC}"
                sleep 2
                ;;
        esac
    done
}

# Run main menu
main
