#!/bin/bash

# Linux Log Monitoring & Alert System

# Resolve paths independently of the current directory
ALERT_ENGINE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd -- "$ALERT_ENGINE_DIR/.." && pwd)"
ALERT_LOG="$PROJECT_ROOT/alerts/alerts.log"

# Log a standardized alert.
# Usage: send_alert SEVERITY CATEGORY MESSAGE

send_alert() {
    local severity="${1:-INFO}"
    local category="${2:-GENERAL}"
    local message="${3:-No message provided}"
    local timestamp

    case "$severity" in
        INFO|WARNING|CRITICAL)
            ;;
        *)
            echo "ERROR: Invalid severity: $severity" >&2
            return 2
            ;;
    esac

    if [ -z "$category" ] || [ -z "$message" ]; then
        echo "ERROR: Category and message are required." >&2
        return 2
    fi

    if ! mkdir -p "$(dirname "$ALERT_LOG")"; then
        echo "ERROR: Cannot create alert directory." >&2
        return 1
    fi

    if ! touch "$ALERT_LOG"; then
        echo "ERROR: Cannot write to $ALERT_LOG" >&2
        return 1
    fi

    timestamp="$(date '+%Y-%m-%d %H:%M:%S')"

    printf '%s | %s | %s | %s\n' \
        "$timestamp" "$severity" "$category" "$message" \
        >> "$ALERT_LOG" || return 1

    printf '[%s] %s: %s\n' "$severity" "$category" "$message"
}
