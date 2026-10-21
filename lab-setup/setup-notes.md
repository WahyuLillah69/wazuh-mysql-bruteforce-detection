# Lab Setup Notes

## Topology

| Component | IP address | Role |
|---|---|---|
| Kali Linux | 192.168.56.20 | Attack simulation |
| MySQL Server | 192.168.56.30 | Authentication log source |
| Wazuh Server | 192.168.56.10 | Log analysis and alert generation |

## Software versions

- Wazuh: 4.12.0
- MySQL: MySQL Community Server 8.4.11
- Attacker: Kali Linux Rolling 2026.2
- Hypervisor and network mode: Oracle VirtualBox (host-only 192.168.56.0/24)

## Wazuh Agent configuration

- Monitored log: MySQL authentication failure log
- Log path: `/var/log/mysql/error.log`

| Configuration | `log_format` |
|---|---|
| Baseline | `mysql_log` |
| Custom | `syslog` |

The custom decoder and rules were evaluated with the `syslog` format.
The baseline run used `mysql_log`. This difference is documented in
[limitations](../docs/limitations.md).

## Notes

The lab is isolated. Do not expose it to external networks.
