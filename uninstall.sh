#!/bin/bash
set -e

# Check for root privileges
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This script must be run as root (sudo)"
    exit 1
fi

# Check for systemd availability
if ! command -v systemctl >/dev/null 2>&1; then
    echo "Error: systemd is required but not found"
    exit 1
fi

# Stop and disable service
systemctl stop fan-control.service 2>/dev/null || true
systemctl disable fan-control.service 2>/dev/null || true

# Set PWM to zero after stopping the service
CONFIG_FILE="/data/fan-control/config"
DEFAULT_FAN_PWM_DEVICE="/sys/class/hwmon/hwmon0/pwm1"

# Read FAN_PWM_DEVICE from config file if it exists, otherwise use default
if [ -f "$CONFIG_FILE" ]; then
    FAN_PWM_DEVICE=$(grep "^FAN_PWM_DEVICE=" "$CONFIG_FILE" | cut -d'=' -f2 | tr -d '"' || echo "$DEFAULT_FAN_PWM_DEVICE")
    # If grep didn't find anything, use default
    [ -z "$FAN_PWM_DEVICE" ] && FAN_PWM_DEVICE="$DEFAULT_FAN_PWM_DEVICE"
else
    FAN_PWM_DEVICE="$DEFAULT_FAN_PWM_DEVICE"
fi

if [ -w "$FAN_PWM_DEVICE" ]; then
    echo "Setting fan PWM to 0..."
    echo 0 > "$FAN_PWM_DEVICE" || echo "Warning: Could not set PWM to 0"
else
    echo "Warning: PWM device not writable or not found: $FAN_PWM_DEVICE"
fi

# Remove system files
echo "Removing system files..."
rm -f /etc/systemd/system/fan-control.service || echo "Warning: Could not remove service file"
rm -f /var/run/fan-control.pid || echo "Warning: Could not remove PID file"

# Remove data files
echo "Removing data files..."
if [ -d "/data/fan-control" ]; then
    rm -rf /data/fan-control || {
        echo "Warning: Could not remove data directory"
        echo "You may need to manually remove /data/fan-control"
    }
else
    echo "Data directory not found, skipping"
fi

# Reload systemd
systemctl daemon-reload

echo "Uninstallation complete. All components removed."
