#!/bin/bash

# Project: e-citizen-monitor-20260624b
# Description: Tracks uptime of Kenyan government portals.
# License: MIT

# Configuration
LOG_FILE="uptime.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
TIMEOUT=10

# ANSI Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Portals to monitor (Name|URL)
PORTALS=(
    "eCitizen Portal|https://accounts.ecitizen.go.ke"
    "KRA iTax|https://itax.kra.go.ke/KRA-Portal/"
    "NTSA TIMS|https://tims.ntsa.go.ke"
    "GHRIS|https://www.ghris.go.ke"
    "IFMIS Kenya|https://ifmis.go.ke"
    "Huduma Kenya|https://www.hudumakenya.go.ke"
    "EACC|https://www.eacc.go.ke"
)

# Notification function (can be extended to Discord/Slack webhooks)
send_alert() {
    local site_name="$1"
    local status_code="$2"
    local message="ALERT: $site_name is DOWN (Status: $status_code) at $TIMESTAMP"
    
    echo -e "${RED}[ALERT]${NC} Sending notification for $site_name..."
    echo "$message" >> "alerts.log"

    # Example Webhook Integration (uncomment and add URL to use)
    # if [[ -n "$WEBHOOK_URL" ]]; then
    #     curl -X POST -H "Content-Type: application/json" -d "{\"content\": \"$message\"}" "$WEBHOOK_URL"
    # fi
}

# Checker function
check_portal() {
    local entry="$1"
    local name=$(echo "$entry" | cut -d'|' -f1)
    local url=$(echo "$entry" | cut -d'|' -f2)

    echo -n "Checking $name... "

    # Use curl to get the HTTP status code
    status_code=$(curl -s -o /dev/null -I -w "%{http_code}" --max-time "$TIMEOUT" "$url")

    if [[ "$status_code" -eq 200 || "$status_code" -eq 301 || "$status_code" -eq 302 ]]; then
        echo -e "[${GREEN}ONLINE${NC}] ($status_code)"
        echo "$TIMESTAMP | $name | UP | $status_code" >> "$LOG_FILE"
    else
        echo -e "[${RED}OFFLINE${NC}] ($status_code)"
        echo "$TIMESTAMP | $name | DOWN | $status_code" >> "$LOG_FILE"
        send_alert "$name" "$status_code"
    fi
}

# Main execution logic
main() {
    echo "============================================="
    echo " e-Citizen Monitor v20260624b "
    echo " Start time: $TIMESTAMP "
    echo "============================================="

    # Check if curl is installed
    if ! command -v curl &> /dev/null; then
        echo "Error: curl is not installed. Please install curl to run this script."
        exit 1
    fi

    # Iterate through defined portals
    for portal in "${PORTALS[@]}"; do
        check_portal "$portal"
    done

    echo "============================================="
    echo "Monitoring cycle complete. Logs updated in $LOG_FILE"
}

# Run the main function
main
