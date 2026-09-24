#!/bin/bash

AUTH_LOG="/var/log/auth.log"
ALERT_LOG="alerts/alerts.log"

echo "=========================================================="
echo "		   AUTHENTICATION LOG MONITOR		        "
echo "=========================================================="

if [ ! -f "$AUTH_LOG" ]; then
	echo "ERROR: $AUTH_LOG not found"
	echo "Use journalctl-based monitoring on this system."
	exit 1
fi

FAILED_LOGINS=$(grep -ic "failed password" "$AUTH_LOG")
SUCCESSFULLY_LOGINS=$(grep -ic "accepted" "$AUTH_LOG")
INVALID_USERS=$(grep -ic "invalid users" "$AUTH_LOG")
SUDO_EVENTS=$(grep -ic "sudo:" "$AUTH_LOG")

THRESHOLD=5

if [ "$FAILED_LOGINS" -gt "$THRESHOLD" ]; then
	MESSAGE="$(date '+%Y-%m-%d %H:%M:%S') | WARNING | High failed login attempts: $FAILED_LOGINS"
	
	echo "$MESSAGE"
	echo "$MESSAGE" >> "$ALERT_LOG"
else
	echo "Authentication Status: NORMAL"
fi

echo "Failed Logins 		: $FAILED_LOGINS"
echo "Successfully Logins	: $SUCCESSFULLY_LOGINS"
echo "Invalid Users		: $INVALID_USERS"
echo "Sudo Events		: $SUDO_EVENTS"

echo "=========================================================="
