# Test Scenarios

## Objective

Evaluate whether the Wazuh detection mechanism can distinguish
normal MySQL authentication activity from repeated authentication
failures that meet the operational brute-force criteria.

## Test Environment

- Attack simulation host: Kali Linux
- Source IP: 192.168.56.20
- Target service: MySQL
- Detection platform: Wazuh 4.12.0
- MySQL version: Community Server 8.4.11

All tests must be performed in the authorized virtual lab.

## Scenario Definitions

| ID | Test condition | Ground truth | Purpose |
|---|---|---|---|
| S1 | One successful authentication | Normal | Establish a single normal-login baseline |
| S2 | Four authentication failures within 60 seconds | Non-attack | Verify that failures below the threshold do not trigger a brute-force alert |
| S3 | Five authentication failures within 60 seconds | Attack | Verify detection when the frequency and timeframe conditions are met |
| S4 | Five authentication failures over more than 60 seconds | Non-attack | Verify the effect of the timeframe condition |
| S5 | Five consecutive successful authentications | Normal | Check for false positives during repeated normal authentication |

## Ground Truth

For this experiment, a brute-force pattern is defined as at least
five authentication failures from the same source IP within 60 seconds.

S3 is the only attack scenario. S1, S2, S4, and S5 are classified
as non-attack scenarios.

The ground-truth label is determined by the scenario conditions,
not by whether Wazuh generates an alert.

## Repetitions

Each scenario is repeated five times under each configuration:

- Baseline: 5 scenarios × 5 repetitions = 25 test cases.
- Custom: 5 scenarios × 5 repetitions = 25 test cases.

Total: 50 test cases across both configurations.

## Evaluation Criteria

The evaluation records:

- Whether the expected authentication events appear in the source log.
- Whether the expected Wazuh rule generates an alert.
- Whether a brute-force alert is generated for the attack scenario.
- Detection rate, false positive rate, and detection time.

An individual authentication-failure alert is not counted as a
brute-force detection unless it represents the defined attack pattern.

## Scope and Limitations

The main experiment uses one source IP and predefined authentication
patterns. Results do not establish detection performance for every
possible attack pattern or production environment.
