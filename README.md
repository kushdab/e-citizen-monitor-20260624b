# E-Citizen Monitor 20260624b

A lightweight Bash-based monitoring tool designed to track the availability and uptime of essential Kenyan government digital portals.

## Monitored Portals
- eCitizen
- KRA iTax
- NTSA TIMS
- GHRIS
- IFMIS Kenya
- Huduma Kenya
- EACC

## Features
- Checks HTTP status codes via `curl`.
- Colorized terminal output for easy reading.
- Logs results to `uptime.log` with timestamps.
- Generates alerts in `alerts.log` when a portal is unreachable.
- Extensible notification system (commented block for Webhooks).

## Installation
1. Ensure you have `curl` installed:
   ```bash
   sudo apt update && sudo apt install curl -y
   ```
2. Clone or download this project.
3. Make the script executable:
   ```bash
   chmod +x uptime.sh
   ```

## Usage
Run the monitor manually:
```bash
./uptime.sh
```

To automate monitoring every 5 minutes, add a cron job:
```bash
*/5 * * * * /path/to/e-citizen-monitor-20260624b/uptime.sh
```

## Requirements
- Bash 4.x+
- curl
