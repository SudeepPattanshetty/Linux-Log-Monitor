#!/bin/bash

echo "=========================================================="
echo "  		LINUX LOG MONITOR			"
echo "=========================================================="

echo "Project Status	: Running"
echo "Monitor Logs	: logs/monitor.log"
echo "Alert Logs	: alerts/alerts.log"

echo "=========================================================="


sudo ./modules/auth_monitor.sh
echo
echo

sudo ./modules/ssh_monitor.ssh
echo
echo

sudo ./modules/error_monitor.sh
