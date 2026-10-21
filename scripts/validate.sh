#!/usr/bin/env bash
set -euo pipefail

fail() { echo "FAIL: $*" >&2; exit 1; }

echo "[1/6] XML well-formedness"
# File decoder Wazuh bisa punya beberapa elemen akar, jadi dibungkus <root> sementara
for f in decoders/*.xml rules/*.xml; do
  { echo "<root>"; cat "$f"; echo "</root>"; } | xmllint --noout - \
    || fail "$f is not well-formed XML"
done

echo "[2/6] Rule IDs unique and in custom range"
ids=$(grep -ohE 'rule id="[0-9]+"' rules/*.xml | grep -oE '[0-9]+' || true)
[ -n "$ids" ] || fail "no rules found"
dups=$(echo "$ids" | sort | uniq -d)
[ -z "$dups" ] || fail "duplicate rule IDs: $dups"
for id in $ids; do
  { [ "$id" -ge 100000 ] && [ "$id" -le 120000 ]; } \
    || fail "rule $id is outside custom range 100000-120000"
done

echo "[3/6] Rule 100201 parameters (frequency 5, timeframe 60, same_source_ip)"
line=$(grep -h 'rule id="100201"' rules/*.xml || true)
[ -n "$line" ] || fail "rule 100201 not found"
echo "$line" | grep -q 'frequency="5"'  || fail "rule 100201 frequency is not 5"
echo "$line" | grep -q 'timeframe="60"' || fail "rule 100201 timeframe is not 60"
grep -q '<same_source_ip' rules/*.xml   || fail "same_source_ip missing"

echo "[4/6] Sample logs"
d=tests/sample-logs
[ -s "$d/mysql-auth-failure.log" ] || fail "mysql-auth-failure.log missing or empty"
for f in mysql-bruteforce-5-events.log mysql-5-events-5-different-ips.log; do
  n=$(grep -c . "$d/$f" || true)
  [ "$n" -eq 5 ] || fail "$f has $n lines, expected 5"
done
same=$(grep -oE "@'[0-9.]+'" "$d/mysql-bruteforce-5-events.log" | sort -u | wc -l)
diff=$(grep -oE "@'[0-9.]+'" "$d/mysql-5-events-5-different-ips.log" | sort -u | wc -l)
[ "$same" -eq 1 ] || fail "5-events log should use one source IP, found $same"
[ "$diff" -eq 5 ] || fail "different-ips log should use 5 source IPs, found $diff"

echo "[5/6] Files referenced by README exist"
for p in LICENSE results/comparison.md docs/limitations.md docs/mitre-mapping.md lab-setup/setup-notes.md; do
  [ -f "$p" ] || fail "missing $p"
done

echo "[6/6] No obvious secrets"
if grep -rnE "ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}" . --exclude-dir=.git; then
  fail "possible GitHub token found"
fi

echo "All checks passed."
