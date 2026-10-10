#!/bin/bash

# ============================================
# Linux Log Monitoring & Alert System
# Day 5 - Service Monitor
# ============================================

ALERT_LOG="alerts/alerts.log"


# ============================================
# Header
# ============================================

echo "=========================================================="
echo "                   SERVICE MONITOR"
echo "=========================================================="


# ============================================
# Check systemctl
# ============================================

if ! command -v systemctl >/dev/null 2>&1; then

    echo "ERROR: systemctl command not found."

    exit 1

fi


# ============================================
# Get Failed Services
# ============================================

FAILED_SERVICES=$(systemctl --failed --no-legend --no-pager)


# ============================================
# Count Failed Services
# ============================================

if [ -z "$FAILED_SERVICES" ]; then

    FAILED_COUNT=0

else

    FAILED_COUNT=$(echo "$FAILED_SERVICES" | wc -l)

fi


# ============================================
# Display Summary
# ============================================

echo
echo "Failed Services : $FAILED_COUNT"
echo


# ============================================
# Check Failed Services
# ============================================

if [ "$FAILED_COUNT" -eq 0 ]; then

    echo "Service Status  : HEALTHY"
    echo
    echo "No failed services detected."

else

    echo "Service Status  : CRITICAL"
    echo
    echo "Failed Services:"
    echo "----------------------------------------------------------"

    echo "$FAILED_SERVICES"

    echo
    echo "Generating alert..."


    # ========================================
    # Create Alert
    # ========================================

    MESSAGE="$(date '+%Y-%m-%d %H:%M:%S') | CRITICAL | Failed services detected | Count=$FAILED_COUNT"

    echo "$MESSAGE" >> "$ALERT_LOG"

fi


# ============================================
# Display Important Services
# ============================================

echo
echo "----------------------------------------------------------"
echo "                 IMPORTANT SERVICES"
echo "----------------------------------------------------------"


SERVICES=("ssh" "cron" "systemd-journald")


for SERVICE in "${SERVICES[@]}"
do

    if systemctl list-unit-files --type=service --no-legend \
        | awk '{print $1}' \
        | grep -qx "${SERVICE}.service"; then

        STATUS=$(systemctl is-active "$SERVICE")

        printf "%-25s : %s\n" "$SERVICE" "$STATUS"

    else

        printf "%-25s : NOT INSTALLED\n" "$SERVICE"

    fi

done


echo
echo "=========================================================="
echo "              SERVICE MONITOR COMPLETED"
echo "=========================================================="
