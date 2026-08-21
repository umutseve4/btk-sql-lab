#!/usr/bin/env bash
# SQL Server ayaga kalkana kadar bekler, sonra sqlcmd kurar ve baglanti testi yapar.
set -e

if ! command -v /opt/mssql-tools18/bin/sqlcmd > /dev/null 2>&1; then
  echo "[wait-for-sql] mssql-tools kuruluyor..."
  curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc > /dev/null
  curl -fsSL https://packages.microsoft.com/config/ubuntu/22.04/prod.list | sudo tee /etc/apt/sources.list.d/mssql-release.list > /dev/null
  sudo apt-get update -qq
  sudo ACCEPT_EULA=Y apt-get install -y -qq mssql-tools18 unixodbc-dev
else
  echo "[wait-for-sql] mssql-tools zaten kurulu."
fi

# PATH'e bagimli kalma: her kabuktan calissin diye symlink
sudo ln -sf /opt/mssql-tools18/bin/sqlcmd /usr/local/bin/sqlcmd
sudo ln -sf /opt/mssql-tools18/bin/bcp /usr/local/bin/bcp

echo "[wait-for-sql] SQL Server bekleniyor (en fazla 180 sn)..."
for i in $(seq 1 60); do
  if sqlcmd -S localhost -U sa -P 'Btk_Lab_2026!' -C -Q "SELECT 1" > /dev/null 2>&1; then
    echo "===== OTOMATIK KONTROL ====="
    sqlcmd -S localhost -U sa -P 'Btk_Lab_2026!' -C -Q "SELECT @@VERSION AS version" | head -5
    echo "PASS: SQL Server 2022 hazir. Baglanti: localhost,1433 / sa"
    exit 0
  fi
  sleep 3
done

echo "===== OTOMATIK KONTROL ====="
echo "FAIL: SQL Server 180 saniyede ayaga kalkmadi."
exit 1
