# Changelog

All notable changes to the UCG Max Fan Control project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- CONTRIBUTING.md with contribution guidelines
- CHANGELOG.md for tracking version history
- TROUBLESHOOTING.md for common issues and solutions
- SECURITY.md for security policy
- CODE_OF_CONDUCT.md for community guidelines
- GitHub issue templates for bug reports and feature requests
- GitHub pull request template

## Recent Changes (Based on Git History)

### [2025-01-13] - Enhanced Reliability and Precision

#### Changed
- Removed locale settings and enhanced temperature smoothing precision
- Refactored temperature smoothing and PWM logic for better precision and reliability
- Improved error handling with atomic writes and logging

#### Fixed
- Ensured fan PWM is set to 0 during uninstallation to prevent unintended behavior

### Previous Features

#### Temperature Management
- Four operational states: OFF, TAPER, ACTIVE, EMERGENCY
- Quadratic response curve for progressive cooling
- Exponential smoothing for noise-resistant temperature tracking
- State transition hysteresis to prevent rapid oscillation

#### Safety Systems
- Emergency override for critical temperatures
- Speed limits and thermal protection
- Hardware validation on startup
- Sensor failure detection and recovery
- Configuration validation with automatic correction

#### Adaptive Learning
- Enhanced adaptive learning system
- Intelligent PWM optimization
- Temperature trend analysis
- Efficiency optimization strategies

#### Configuration
- User-configurable temperature thresholds
- Adjustable fan speed ranges
- Customizable smoothing factors
- Flexible check intervals and taper duration

#### Installation
- One-line installation command
- Support for branch-specific installations
- Smart service management (fresh install or hot update)
- Automatic configuration file creation with defaults

#### Monitoring
- Comprehensive logging system
- Real-time status updates
- Temperature delta tracking
- Learning activity logs
- Configuration change notifications

---

## Version History Format

Future releases will follow this format:

## [X.Y.Z] - YYYY-MM-DD

### Added
- New features

### Changed
- Changes in existing functionality

### Deprecated
- Soon-to-be removed features

### Removed
- Removed features

### Fixed
- Bug fixes

### Security
- Security improvements or fixes

---

**Note**: This changelog was created on 2025-11-13. Previous changes were reconstructed from git commit history and README documentation.
