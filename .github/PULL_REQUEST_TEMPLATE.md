# Pull Request

## Description

A clear and concise description of what this PR does.

Fixes #(issue number)

## Type of Change

- [ ] Bug fix (non-breaking change that fixes an issue)
- [ ] New feature (non-breaking change that adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update
- [ ] Code refactoring (no functional changes)
- [ ] Performance improvement
- [ ] Configuration change

## Changes Made

Detailed list of changes:

-
-
-

## Testing

### Test Environment

- **Device Model**: (e.g., UCG-Max, UCG-Fibre, UXG-Fibre, UNVR)
- **UniFi OS Version**: (e.g., 4.0.6)
- **Test Duration**: (e.g., 24 hours, 1 week)

### Test Scenarios

Describe how you tested these changes:

- [ ] Cold start (system below MIN_TEMP)
- [ ] Hot start (system above MIN_TEMP)
- [ ] Temperature rise (OFF → ACTIVE → EMERGENCY)
- [ ] Temperature drop (EMERGENCY → ACTIVE → TAPER → OFF)
- [ ] Configuration reload
- [ ] Service restart
- [ ] Long-term stability (if applicable)
- [ ] Other:

### Test Results

Provide test results, logs, or screenshots if applicable:

```
# Temperature behavior

# PWM behavior

# State transitions

```

## Configuration Impact

- [ ] No configuration changes required
- [ ] New optional configuration parameters added
- [ ] Existing configuration parameters modified
- [ ] Configuration migration required

If configuration changes are needed, document them here:

```bash
# New or modified configuration parameters

```

## Breaking Changes

List any breaking changes and migration steps:

-
-

## Documentation

- [ ] README.md updated (if needed)
- [ ] TROUBLESHOOTING.md updated (if needed)
- [ ] CHANGELOG.md updated
- [ ] Code comments added/updated
- [ ] Configuration examples updated

## Code Quality

- [ ] Code follows project style guidelines
- [ ] Comments added for complex logic
- [ ] Error handling implemented
- [ ] Logging added for important operations
- [ ] Safety checks implemented (if hardware-related)
- [ ] Input validation added (if applicable)

## Safety Considerations

For hardware control changes:

- [ ] PWM values are validated and clamped
- [ ] Emergency mode still functions correctly
- [ ] Fail-safe behavior maintained
- [ ] No risk of leaving fans in undefined state
- [ ] Hysteresis prevents rapid oscillation

## Checklist

- [ ] My code follows the project's code style
- [ ] I have performed a self-review of my code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings or errors
- [ ] I have tested my changes thoroughly
- [ ] Any dependent changes have been merged and published

## Additional Notes

Any additional information, concerns, or discussion points:

-
-

## Screenshots/Logs (if applicable)

Add screenshots, graphs, or relevant log excerpts here.

---

**By submitting this PR, I confirm that**:
- [ ] I have read and agree to follow the [Code of Conduct](../CODE_OF_CONDUCT.md)
- [ ] I have read the [Contributing Guidelines](../CONTRIBUTING.md)
- [ ] My contribution is licensed under the MIT License
