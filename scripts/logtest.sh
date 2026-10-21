#!/usr/bin/env bash
# Jalankan di Wazuh Manager pada lab uji (butuh sudo dan decoder/rule sudah terpasang).
set -euo pipefail

LOGTEST=/var/ossec/bin/wazuh-logtest
fail() { echo "FAIL: $*" >&2; exit 1; }
count() { grep -c "id: '$2'" <<<"$1" || true; }

check() {  # file, expected 100200 alerts, expected 100201 alerts
  out=$(sudo "$LOGTEST" < "$1" 2>&1)
  a=$(count "$out" 100200); b=$(count "$out" 100201)
  if [ "$a" -ne "$2" ] || [ "$b" -ne "$3" ]; then
    echo "$out"
    fail "$1: got 100200=$a 100201=$b, expected $2/$3"
  fi
  echo "OK  $1 (100200=$a, 100201=$b)"
}

check tests/sample-logs/mysql-auth-failure.log 1 0
check tests/sample-logs/mysql-bruteforce-5-events.log 4 1
check tests/sample-logs/mysql-5-events-5-different-ips.log 5 0
echo "All logtest checks passed."
