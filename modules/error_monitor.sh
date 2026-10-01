#!/bin/bash

LOG_FILE="/var/log/syslog"

ALERT_LOG="alerts/alerts.log"

ERROR_THRESHOLD=5
WARNING_THRESHOLD=5

echo "=========================================================="
echo "			SYSTEM ERROR MONITOR			"
echo "=========================================================="

echo "Log File : $LOG_FILE"
echo 

if [ ! -f "$LOG_FILE" ]; then
	echo "Error: Log file not found"
	echo "$LOG_FILE"
	exit 1
fi


ERROR_COUNT=$(sudo grep -icE "\berror\b" "$LOG_FILE")
WARNING_COUNT=$(sudo grep -icE "\bwarning\b|\bwarn\b" "$LOG_FILE")
FAILED_COUNT=$(sudo grep -icE "\bfailed\b|\bfailure\b" "$LOG_FILE")
CRITICAL_COUNT=$(sudo grep -icE "\bcritical\b|\bcrit\b" "$LOG_FILE")

echo "----------------------------------------------------------"
echo "			     LOG SUMMARY			"
echo "----------------------------------------------------------"

echo "----------------------------------------------------------"
echo "                    LOG SUMMARY"
echo "----------------------------------------------------------"

echo "Errors Detected       : $ERROR_COUNT"
echo "Warnings Detected     : $WARNING_COUNT"
echo "Failed Events         : $FAILED_COUNT"
echo "Critical Events       : $CRITICAL_COUNT"

echo


# ============================================
# Determine System Status
# ============================================

STATUS="NORMAL"

if [ "$CRITICAL_COUNT" -gt 0 ]; then

    STATUS="CRITICAL"

elif [ "$ERROR_COUNT" -ge "$ERROR_THRESHOLD" ]; then

    STATUS="WARNING"

elif [ "$WARNING_COUNT" -ge "$WARNING_THRESHOLD" ]; then

    STATUS="WARNING"

fi


echo "Overall Status        : $STATUS"


# ============================================
# Generate Alert
# ============================================

if [ "$STATUS" = "WARNING" ]; then

    MESSAGE="$(date '+%Y-%m-%d %H:%M:%S') | WARNING | Log errors exceeded threshold | Errors=$ERROR_COUNT | Warnings=$WARNING_COUNT"

    echo "$MESSAGE" >> "$ALERT_LOG"

    echo
    echo "WARNING: Log error threshold exceeded."

fi


if [ "$STATUS" = "CRITICAL" ]; then

    MESSAGE="$(date '+%Y-%m-%d %H:%M:%S') | CRITICAL | Critical events detected | Critical=$CRITICAL_COUNT"

    echo "$MESSAGE" >> "$ALERT_LOG"

    echo
    echo "CRITICAL: Critical events detected."

fi


# ============================================
# Recent Errors
# ============================================

echo
echo "----------------------------------------------------------"
echo "                    RECENT ERRORS"
echo "----------------------------------------------------------"

sudo grep -iE "\berror\b|\bcritical\b|\bfailed\b" "$LOG_FILE" | tail -10


echo
echo "=========================================================="
echo "              ERROR MONITOR COMPLETED"
echo "=========================================================="
