#!/usr/bin/env bash
# Waits for SQL Server, installs sqlcmd when needed, and verifies connectivity.
set -euo pipefail

sa_password="${MSSQL_SA_PASSWORD:-Btk_Lab_2026!}"

if ! command -v /opt/mssql-tools18/bin/sqlcmd >/dev/null 2>&1; then
  echo "[wait-for-sql] Installing mssql-tools18..."
  curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \
    | gpg --dearmor \
    | sudo tee /usr/share/keyrings/microsoft-prod.gpg >/dev/null
  curl -fsSL https://packages.microsoft.com/config/ubuntu/22.04/prod.list \
    | sed 's#deb \[#deb [signed-by=/usr/share/keyrings/microsoft-prod.gpg #' \
    | sudo tee /etc/apt/sources.list.d/mssql-release.list >/dev/null
  sudo apt-get update -qq
  sudo ACCEPT_EULA=Y apt-get install -y -qq mssql-tools18 unixodbc-dev
else
  echo "[wait-for-sql] mssql-tools18 is already installed."
fi

sudo ln -sf /opt/mssql-tools18/bin/sqlcmd /usr/local/bin/sqlcmd
sudo ln -sf /opt/mssql-tools18/bin/bcp /usr/local/bin/bcp

echo "[wait-for-sql] Waiting for SQL Server (maximum 180 seconds)..."
for _ in $(seq 1 60); do
  if sqlcmd -S localhost -U sa -P "$sa_password" -C -b -V 16 \
    -Q "SET NOCOUNT ON; SELECT 1;" >/dev/null 2>&1; then
    echo "===== OTOMATIK KONTROL ====="
    sqlcmd -S localhost -U sa -P "$sa_password" -C -b -V 16 \
      -Q "SELECT @@VERSION AS version;" | head -5
    echo "PASS: SQL Server 2022 is ready at localhost,1433."
    exit 0
  fi
  sleep 3
done

echo "===== OTOMATIK KONTROL ====="
echo "FAIL: SQL Server did not become ready within 180 seconds."
exit 1
