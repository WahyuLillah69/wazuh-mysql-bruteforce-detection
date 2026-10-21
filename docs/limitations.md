# Limitations

- The main evaluation used a single source IP.
- Detection was evaluated against predefined scenarios and one threshold
  (5 failures in 60 seconds).
- Baseline and custom tests ran on different days with different Wazuh
  log-format settings, so the comparison is not fully controlled.
- Only 5 attack runs and 20 non-attack runs per configuration; 0% false
  positives on this sample does not imply none in other conditions.
- Results do not generalize to every MySQL version, log format, attack
  pattern, or production environment.

## Future work

- Re-run baseline and custom on the same day with identical log format.
- Test distributed attacks (multiple source IPs) and slow attacks.
- Move rules into a version-controlled pipeline with automated tests.
