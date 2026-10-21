# Baseline vs Custom Comparison

## Scenarios

| ID | Description | Type |
|---|---|---|
| S1 | One successful authentication | Non-attack |
| S2 | Four authentication failures within 60 seconds | Non-attack |
| S3 | Five authentication failures within 60 seconds | Attack (ground truth) |
| S4 | Five authentication failures over more than 60 seconds | Non-attack |
| S5 | Five consecutive successful authentications | Non-attack |

Each scenario was run five times per configuration (25 test cases per configuration).

## Summary

| Metric | Baseline | Custom |
|---|---:|---:|
| Brute-force detection rate | 0% (0/5) | 100% (5/5) |
| False positive rate | 0% (0/20) | 0% (0/20) |
| Mean detection time | Not defined | 4.584 seconds |

Detection rate is measured on S3 only. Individual authentication-failure
alerts do not count as brute-force detections. False positive rate is
measured across the 20 non-attack runs (S1, S2, S4, S5).

## Per-run detection time (custom, S3)

| Run | Detection time (s) |
|---|---:|
| 1 | 4.385 |
| 2 | 4.746 |
| 3 | 4.662 |
| 4 | 4.596 |
| 5 | 4.533 |

Mean: 4.584 seconds.

## Notes

- Baseline used `log_format` = `mysql_log`; custom used `syslog`.
- Baseline and custom tests were run on different days, so the comparison
  is not fully controlled.

See [limitations](../docs/limitations.md) for the caveats on this comparison.
