# Linux Log Monitoring & Alert System

A Bash-based Linux project for monitoring system logs, detecting important events, generating alerts, and creating reports.

## Project Objective

The goal of this project is to build a Linux log monitoring system that can:

- Monitor Linux system logs
- Detect errors and warnings
- Monitor authentication events
- Monitor SSH activity
- Detect failed services
- Generate alerts
- Maintain monitoring logs
- Generate reports

## Technologies

- Linux
- Bash Shell Scripting
- grep
- awk
- sed
- journalctl
- systemctl
- dmesg
- Cron

## Project Structure

```text
Linux-Log-Monitor/
├── README.md
├── dashboard.sh
├── modules/
├── alerts/
├── logs/
├── reports/
├── config/
├── docs/
└── screenshots/






### Centralized Alert Engine

- Created a reusable alert logging function.
- Standardized INFO, WARNING, and CRITICAL severity levels.
- Added timestamps and alert categories.
- Created an alert viewer with severity filters.
- Integrated the alert engine into monitoring modules.
- Tested alerts using sample events.
