# Limitations

## Experimental design
- All main tests used a single attacker source IP (192.168.56.20). Behavior
  with multiple source IPs was checked only with `wazuh-logtest` and is not
  part of the 25 main runs or the reported metrics.
- `same_source_ip` separates source IPs but not the targeted MySQL account.
- Five repetitions per scenario, with fixed delays between attempts
  (about 1 s in S2 and S3, 16 s in S4).
- S1 and S5 contain only successful logins and produce no failure events in
  `error.log`, so they do not test discrimination. Only S2 and S4 (10 runs
  per configuration) are informative for false positives; read the 0% FPR
  with this in mind.
- A 100% detection rate applies only to the defined ground truth (five
  failures within 60 s from the same IP), not to other brute-force variants.
- Mean detection time (4.584 s) is about 90.8% attack duration (4.163 s) and
  9.2% Wazuh latency (0.421 s), so it depends on the roughly 1 s attempt interval.

## Comparison validity
- Baseline (`mysql_log`) and custom (`syslog`) tests ran on different days
  with different log-format settings, so the comparison is not fully controlled.
- The baseline finding is limited to Wazuh 4.12.0 and rule file
  `0295-mysql_rules.xml`. It does not claim Wazuh cannot detect brute force.
- The JSON archive was enabled only during baseline testing. For the custom
  configuration, event reception is supported indirectly (65 + 5 alerts = 70
  failures in the MySQL log).

## Scope
- Wazuh 4.12.0, MySQL Community Server 8.4.11, VirtualBox lab.
- Not evaluated: other versions, log formats, attack patterns, or load.

## Future work
- Re-run baseline and custom on the same day with identical log format.
- Test distributed attacks (multiple source IPs), different target accounts,
  and slower or faster attempt intervals.
- Enable the JSON archive in all configurations.
- Move rules into a version-controlled pipeline with automated tests.
