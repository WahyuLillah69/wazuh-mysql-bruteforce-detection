# MITRE ATT&CK Mapping

| Technique | ID | Tactic | Related rule |
|---|---|---|---|
| Brute Force | T1110 | Credential Access | 100201 |

Rule 100200 records individual authentication failures (supporting
evidence). Rule 100201 correlates five failures within 60 seconds from
the same source IP, which this project treats as a brute-force pattern.
