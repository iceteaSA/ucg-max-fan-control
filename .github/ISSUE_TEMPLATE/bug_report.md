---
name: Bug Report
about: Report a bug or issue with the fan control system
title: '[BUG] '
labels: bug
assignees: ''
---

## Bug Description

A clear and concise description of the bug.

## System Information

- **Device Model**: (e.g., UCG-Max, UCG-Fibre, UXG-Fibre, UNVR)
- **UniFi OS Version**: (e.g., 4.0.6)
- **Script Branch/Version**: (e.g., main, dev, commit hash)

## Current Behavior

What is happening? Be specific.

## Expected Behavior

What should happen instead?

## Steps to Reproduce

1. Go to '...'
2. Run command '....'
3. See error

## Configuration

```bash
# Paste your /data/fan-control/config here
# Remove or redact any sensitive information

```

## Logs

```bash
# Paste relevant logs from: journalctl -u fan-control.service -n 100
# Include any ERROR, ALERT, or FATAL messages

```

## Temperature and Fan Data

```bash
# Current temperature
ubnt-systool cputemp
# Output:

# Current PWM value
cat /sys/class/hwmon/hwmon0/pwm1
# Output:

# Service status
systemctl status fan-control.service
# Output:

```

## Additional Context

Add any other context about the problem here (screenshots, graphs, etc.)

## Attempted Solutions

What have you already tried to fix the issue?

- [ ] Restarted the service
- [ ] Reset configuration to defaults
- [ ] Checked logs for errors
- [ ] Verified hardware access
- [ ] Checked TROUBLESHOOTING.md
- [ ] Other:

## Frequency

- [ ] This happens consistently
- [ ] This happens intermittently
- [ ] This happened once

## Impact

- [ ] Critical - System safety concern
- [ ] High - Service not functioning
- [ ] Medium - Service functioning but with issues
- [ ] Low - Minor inconvenience
