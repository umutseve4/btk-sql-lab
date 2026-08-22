#!/usr/bin/env bash
# Runs the repository SQL against a real SQL Server container.
set -euo pipefail

container_name="${1:?container name is required}"
sa_password="${2:?SA password is required}"
timeout_seconds="${SQL_STARTUP_TIMEOUT_SECONDS:-180}"
interval_seconds=3
elapsed=0

find_sqlcmd() {
  local candidate
  for candidate in /opt/mssql-tools18/bin/sqlcmd /opt/mssql-tools/bin/sqlcmd; do
    if docker exec "$container_name" test -x "$candidate"; then
      printf '%s' "$candidate"
      return 0
    fi
  done
  return 1
}

sqlcmd_path=""
until sqlcmd_path="$(find_sqlcmd 2>/dev/null)"; do
  if (( elapsed >= timeout_seconds )); then
    echo "FAIL: sqlcmd was not found in the SQL Server container within ${timeout_seconds}s."
    exit 1
  fi
  sleep "$interval_seconds"
  elapsed=$((elapsed + interval_seconds))
done

until docker exec "$container_name" "$sqlcmd_path" \
  -S localhost -U sa -P "$sa_password" -C -b -V 16 \
  -Q "SET NOCOUNT ON; SELECT 1;" >/dev/null 2>&1; do
  if (( elapsed >= timeout_seconds )); then
    echo "FAIL: SQL Server did not become ready within ${timeout_seconds}s."
    exit 1
  fi
  sleep "$interval_seconds"
  elapsed=$((elapsed + interval_seconds))
done

docker exec "$container_name" "$sqlcmd_path" \
  -S localhost -U sa -P "$sa_password" -C -b -V 16 \
  -i /workspace/sql/00_smoke_test.sql

database_exists="$(docker exec "$container_name" "$sqlcmd_path" \
  -S localhost -U sa -P "$sa_password" -C -b -V 16 -h -1 -W \
  -Q "SET NOCOUNT ON; SELECT CASE WHEN DB_ID('btk') IS NULL THEN 0 ELSE 1 END;")"
if [[ "$database_exists" != "1" ]]; then
  echo "FAIL: smoke test did not create the btk database."
  exit 1
fi

if docker exec "$container_name" "$sqlcmd_path" \
  -S localhost -U sa -P "DefinitelyWrong_2026!" -C -b -V 16 \
  -Q "SELECT 1;" >/dev/null 2>&1; then
  echo "FAIL: invalid credentials were unexpectedly accepted."
  exit 1
fi

echo "===== OTOMATIK KONTROL ====="
echo "PASS: SQL Server accepted valid credentials."
echo "PASS: sql/00_smoke_test.sql completed with error-on-failure enabled."
echo "PASS: btk database existence assertion passed."
echo "PASS: invalid-credential failure path was rejected."
