# Unifi Gateway/NVR Intelligent Fan Control

Advanced temperature management for Ubiquiti Unifi Gateway/NVR devices running UniFi OS 4+ that has a fan.

Confirmed working on: UCG-Max, UCG-Fibre, UXG-Fibre, UNVR

## Features
- 🎛️ **Four Operational States**: 
  - **OFF**: Fan disabled (temp < activation threshold)
  - **TAPER**: Post-cooling minimum speed period
  - **ACTIVE**: Quadratic response curve (temp ≥ activation threshold)
  - **EMERGENCY**: Immediate full speed (255 PWM) (critical temps)
- 🚨 **Emergency Override**: Instant full speed at critical temps with hysteresis for stable transitions
- 📈 **Quadratic Response**: Progressive cooling curve for optimal noise/performance
- 🧠 **Enhanced Adaptive Learning**: Intelligent PWM optimization with temperature trend analysis
- 📉 **Exponential Smoothing**: Noise-resistant temperature tracking
- 🛡️ **Robust Safety Systems**: 
  - Speed limits and thermal protection
  - Hardware validation
  - Sensor failure detection and recovery
  - Configuration validation
- 🔄 **State Transition Hysteresis**: Prevents rapid state oscillation

## Installation
```bash
curl -sSL https://raw.githubusercontent.com/iceteaSA/ucg-max-fan-control/main/install.sh | sudo bash
```

### Using a Different Branch
If you want to install from a specific branch (e.g., for testing new features):

**Method 1: Direct URL**
```bash
# Replace 'dev' with your desired branch name
curl -sSL https://raw.githubusercontent.com/iceteaSA/ucg-max-fan-control/dev/install.sh | sudo bash
```

**Method 2: Environment Variable**
```bash
# Set the branch name via environment variable
FAN_CONTROL_BRANCH=dev curl -sSL https://raw.githubusercontent.com/iceteaSA/ucg-max-fan-control/main/install.sh | sudo bash
```

### Manual Installation
If you prefer to inspect the code before installation:
```bash
# Clone the repository
git clone https://github.com/iceteaSA/ucg-max-fan-control.git
cd ucg-max-fan-control

# Optionally checkout a specific branch
# git checkout dev

# Run the installer (you can also use FAN_CONTROL_BRANCH to override the branch)
sudo ./install.sh
# Or with a specific branch:
# sudo FAN_CONTROL_BRANCH=dev ./install.sh
```

## Configuration
Edit `/data/fan-control/config`:
```bash
# Core Thresholds
MIN_TEMP=60            # Base threshold (°C)
MAX_TEMP=85            # Critical temperature (°C)
HYSTERESIS=5           # Temperature buffer (°C)

# Fan Behavior
MIN_PWM=91        # Minimum active speed (0-255)
MAX_PWM=255       # Maximum speed (0-255)
MAX_PWM_STEP=25   # Maximum speed change per adjustment
                  # Note: Due to hardware limitations, actual PWM values may vary slightly from requested values

# Advanced Tuning
ALPHA=20          # Smoothing factor, lower values make the smoothed temp follow raw temp more closely (0-100 raw→smooth)
DEADBAND=1        # Temperature stability threshold (°C)
LEARNING_RATE=5   # Hourly PWM optimization step size
TAPER_MINS=90     # Cool-down duration (minutes)
CHECK_INTERVAL=15 # Temperature check frequency (seconds)

# You probably shouldn't touch this
FAN_PWM_DEVICE="/sys/class/hwmon/hwmon0/pwm1"
OPTIMAL_PWM_FILE="/data/fan-control/optimal_pwm"
```

> **Note**: The script automatically checks for missing configuration parameters and adds them with default values if they're not present in the config file. This ensures that all required parameters are always available, even if you've edited the config file manually.

Apply changes:
```bash
systemctl restart fan-control.service
```

## Operational Overview
| State       | Trigger Condition          | Exit Condition                   | Behavior                          |
|-------------|----------------------------|----------------------------------|-----------------------------------|
| **OFF**     | <65°C (60+5)               | Temp ≥ 65°C                      | Fan disabled                      |
| **TAPER**   | Temp ≤ 60°C from ACTIVE    | Temp ≥ 67°C or timer elapsed     | Minimum speed for configured mins |
| **ACTIVE**  | 65°C - 85°C                | Temp ≤ 60°C or Temp ≥ 85°C       | Quadratic speed response          |
| **EMERGENCY**| ≥85°C                     | Temp ≤ 80°C (with hysteresis)    | Immediate full speed (255 PWM)    |

### State Transitions
- **OFF → ACTIVE**: Temperature rises above activation threshold (65°C)
- **ACTIVE → TAPER**: Temperature drops below minimum threshold (60°C)
- **ACTIVE → EMERGENCY**: Temperature reaches critical level (85°C)
- **TAPER → OFF**: Cool-down period (default: 90 minutes) completes
- **TAPER → ACTIVE**: Temperature rises significantly above activation threshold (67°C, with 2°C buffer)
- **EMERGENCY → ACTIVE**: Temperature drops significantly below critical level (80°C, with 5°C hysteresis)

## Monitoring & Logging
Key operational signals:
```log
# Temperature Monitoring
TEMP: RAW=68℃ | SMOOTH=65℃ | DELTA=-3℃

# Speed Calculations
CALC: temp_diff=5℃ | range=20℃ | speed=100pwm

# State Transitions
STATE: OFF→ACTIVE (67℃ ≥ 65℃)
STATE: ACTIVE→TAPER (59℃ ≤ 60℃)
STATE: →EMERGENCY (86℃ ≥ 85℃)
STATE: EMERGENCY→ACTIVE (79℃ ≤ 80℃)
STATE: TAPER→ACTIVE (67℃ ≥ 67℃)

# Speed Changes
SET: 55→80pwm | Reason: Ramp-up limited: 55→80pwm
SET: 120→255pwm | Reason: EMERGENCY: Temp 86℃ ≥ 85℃

# Enhanced Learning System
LEARNING: 80→85pwm (+5 (rising temp 2℃)) [Rate=7]
LEARNING: 95→90pwm (-5 (stable below threshold)) [Rate=5]
LEARNING: 100→99pwm (-1 (efficiency optimization)) [Rate=5]

# Error Handling
ERROR: Failed to read temperature (attempt 1)
ALERT: Multiple temperature read failures - using last known temperature
SAFETY: Activating emergency mode due to sensor failure

# Configuration Validation
CONFIG: Invalid MIN_TEMP value: 25 (should be between 30 and 80), using default: 60
CONFIG: Updating configuration file with corrected values

# Configuration Management
CONFIG: Missing parameter detected: CHECK_INTERVAL
CONFIG: Updating configuration file with 1 missing parameters
CONFIG: Configuration file updated successfully

# System Status
STATUS: State=ACTIVE | PWM=120 | Temp=72℃
STATUS: State=EMERGENCY | PWM=255 | Temp=86℃
```

View logs with:
```bash
journalctl -u fan-control.service -f          # Live monitoring
journalctl -u fan-control.service --since "10 minutes ago"  # Recent history
```

## Technical Implementation
- **Quadratic Response Curve**:

<br>

$$
PWM = MIN_{PWM} + \frac{(temp_{diff}^2 \times (MAX_{PWM} - MIN_{PWM}))}{temp_{range}^2}
$$

Where:  
`temp_diff = current_temp - activation_temp`  
`temp_range = MAX_TEMP - activation_temp`


- **Exponential Smoothing**:

<br>

$$
smoothed_{temp} = \frac{\alpha \times previous_{smooth} + (100 - \alpha) \times raw_{temp}}{100}
$$

(α configured via ALPHA parameter)

<br>


- **Enhanced Adaptive Learning**:
  - Adjusts optimal PWM based on thermal performance every 30 minutes (configurable)
  - Uses adaptive learning rate based on temperature stability
  - Implements three learning strategies:
    1. Proactive PWM increase when temperature is rising
    2. PWM reduction when temperature is stable below threshold
    3. Efficiency optimization when running faster than necessary with stable temperatures


- **Robust Error Handling**:
  - Tracks consecutive temperature reading failures
  - Implements safety measures after multiple failures
  - Uses last known temperature when readings fail
  - Activates fans proactively during sensor uncertainty

- **Configuration Validation**:
  - Validates all parameters against reasonable ranges
  - Automatically corrects invalid settings
  - Prevents misconfiguration issues

- **Hardware PWM Limitations**:  
  Due to device hardware limitations, the actual PWM values applied may differ from the requested values
  (e.g., setting 50 might result in ~48, or 100 might result in ~92)

## Maintenance
```bash
# Service Management
systemctl status fan-control.service   # Current state
systemctl restart fan-control.service  # Apply config changes

# Full Removal
/data/fan-control/uninstall.sh
```

## Project Structure
- **fan-control.sh**: The main script that monitors temperature and controls fan speed
- **install.sh**: Installation script that copies files and sets up the systemd service
  - Supports installation from different branches via the `FAN_CONTROL_BRANCH` environment variable
  - Automatically downloads required files if not found locally
- **uninstall.sh**: Script to remove the fan control system
- **fan-control.service**: Systemd service configuration

## Credits & Acknowledgments
- **Thermal Research**: [UCG-Max Thermal Thread](https://www.reddit.com/r/Ubiquiti/comments/1fr8xyt/)
- **System Integration**: SierraSoftworks service patterns

[☕Buy me a coffee](https://ko-fi.com/H2H719VB0U)

---

**Disclaimer**: Community project - Not affiliated with Ubiquiti Inc.  
**Compatibility**: Verified on UniFi OS 4.0.0+ 
**License**: MIT
