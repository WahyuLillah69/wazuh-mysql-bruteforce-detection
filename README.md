# MySQL Brute-Force Detection with Wazuh

A security monitoring and detection engineering project that identifies
repeated MySQL authentication failures using a custom Wazuh decoder and
correlation rules.

This project was developed as part of an academic research project and
evaluated in a controlled virtual machine lab.

In a controlled lab, the custom rule detected 5 of 5 simulated brute-force runs (mean detection time: 4.584 seconds) with no false positives across 20 non-attack runs. The built-in rules raised no brute-force alert in 5 attack runs, although individual authentication failures were detected.

> **Scope:** Authorized security testing in an isolated lab environment only.
> This repository is a research prototype, not a production-ready security solution.

## Objectives

- Parse MySQL authentication failure logs using a custom Wazuh decoder.
- Extract the source username and IP address from relevant log events.
- Detect repeated authentication failures using custom Wazuh rules.
- Compare built-in Wazuh detection (baseline) against the custom mechanism.
- Evaluate detection rate, false positive rate, and detection time.

## Lab Architecture

The lab consists of three virtual machines:

| Component | IP address | Role |
|---|---|---|
| Kali Linux | `192.168.56.20` | Attack simulation |
| MySQL Server | `192.168.56.30` | Authentication log source |
| Wazuh Server | `192.168.56.10` | Log analysis and alert generation |

The Wazuh Agent collects the configured MySQL log and forwards events
to the Wazuh Manager for decoding and rule evaluation.

See [lab setup notes](lab-setup/setup-notes.md) for environment details.

## Detection Logic

### Custom Decoder

The decoder recognizes the pattern `Access denied for user` and extracts:

- `srcuser`: the MySQL username associated with the failed authentication.
- `srcip`: the source IP address associated with the event.

Configuration: `decoders/mysql_custom_decoders.xml`

### Custom Rules

| Rule ID | Level | Purpose |
|---|---:|---|
| `100200` | 5 | Identify an individual authentication failure |
| `100201` | 10 | Detect five matching failures within 60 seconds from the same source IP |

The threshold is the operational definition of a brute-force pattern
used in this experiment. It is not a universal definition for every environment.

Configuration: `rules/mysql_custom_rules.xml`

## Experimental Results

The thesis experiment evaluated 25 test cases per configuration, using
five scenarios with five repetitions per scenario.

Detection rate is measured across the five repetitions of S3, the
only ground-truth attack scenario. Individual authentication-failure
alerts do not count as brute-force detections.

False positive rate (FPR) is measured across 20 non-attack test cases
per configuration.

Only S2 and S4 produce failed logins; S1 and S5 contain successful logins
only. The informative false-positive evidence therefore comes from 10 of the
20 non-attack runs. See [limitations](docs/limitations.md).

| Metric | Baseline | Custom |
|---|---:|---:|
| Brute-force detection rate | 0% (0/5) | 100% (5/5) |
| False positive rate | 0% (0/20) | 0% (0/20) |
| Mean detection time | Not defined | 4.584 seconds |

The custom configuration detected all five repetitions of the scenario
defined as an attack. The baseline configuration did not generate a
brute-force alert in those five repetitions, although it detected
individual authentication failures.


### Interpretation and Limitations

These results apply only to the tested scenarios and laboratory conditions.

In the original experiment, baseline and custom configurations were tested
on different days and used different Wazuh log-format settings. This is a
limitation when comparing the two results.

See `results/comparison.md` and `docs/limitations.md` for further details.

## Repository Structure

- `decoders/`: Custom Wazuh decoder.
- `rules/`: Custom Wazuh rules.
- `attack-simulation/`: Authorized laboratory simulation procedures.
- `lab-setup/`: Lab architecture and environment configuration.
- `tests/`: Test scenarios and sample logs.
- `results/`: Baseline results, custom results, and comparison.
- `docs/`: Detection logic, MITRE ATT&CK mapping, and limitations.

## Testing

On the Wazuh Manager in the test lab, run:

`sudo /var/ossec/bin/wazuh-logtest`

Submit a sample authentication failure from
`tests/sample-logs/mysql-auth-failure.log`.

Verify the decoded fields and matched rule. Rule `100201` requires the
configured frequency and time-window conditions to be satisfied.

To test rule `100201`, run `sudo /var/ossec/bin/wazuh-logtest` and submit all five lines from `tests/sample-logs/mysql-bruteforce-5-events.log` in the same session. The brute-force rule should match on the fifth event.

## Limitations

- The main evaluation used one source IP.
- Detection was evaluated against predefined scenarios and thresholds.
- Baseline and custom tests used different log-format settings and were
  conducted on different days.
- The results do not establish performance for every MySQL version,
  log format, attack pattern, or production environment.

## MITRE ATT&CK Mapping

- T1110: Brute Force (Credential Access)

See [docs/mitre-mapping.md](docs/mitre-mapping.md).

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE).

## Disclaimer

Use simulation procedures only against systems you own or are explicitly
authorized to test. Do not publish passwords, tokens, or sensitive logs.
