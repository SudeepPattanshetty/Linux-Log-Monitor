
#!/bin/bash

# ============================================
# Day 6 - Alert Viewer
# ============================================

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"
ALERT_LOG="$PROJECT_ROOT/alerts/alerts.log"

FILTER="${1:-ALL}"

case "$FILTER" in
    ALL|INFO|WARNING|CRITICAL)
        ;;
    *)
        echo "Usage: $0 [ALL|INFO|WARNING|CRITICAL]"
        exit 2
        ;;
esac

echo "=================================================="
echo "                 ALERT VIEWER"
echo "=================================================="
echo "Filter: $FILTER"
echo

if [ ! -f "$ALERT_LOG" ]; then
    echo "No alert log exists yet."
    exit 0
fi

if [ ! -s "$ALERT_LOG" ]; then
    echo "Alert log is empty."
    exit 0
fi

if [ "$FILTER" = "ALL" ]; then
    cat "$ALERT_LOG"
else
    grep -F "| $FILTER |" "$ALERT_LOG" \
        || echo "No $FILTER alerts found."
fi

echo
echo "=================================================="
echo "                VIEW COMPLETED"
echo "=================================================="
