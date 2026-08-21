#!/usr/bin/env bash
# SQL Server ayaga kalkana kadar bekler, sonra sqlcmd kurar ve baglanti testi yapar.
set -e

echo "[wait-for-sql] mssql-tools kuruluyor..."
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc > /dev/null
curl -fsSL https://packages.microsoft.com/config/ubuntu/22.04/prod.list | sudo tee /etc/apt/sources.list.d/mssql-release.list > /dev/null
sudo apt-get update -qq
sudo ACCEPT_EULA=Y apt-get install -y -qq mssql-tools18 unixodbc-dev > /dev/null

if ! grep -q mssql-tools18 ~/.bashrc; then
  echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc
fi
export PATH="$PATH:/opt/mssql-tools18/bin"

echo "[wait-for-sql] SQL Server bekleniyor (en fazla 90 sn)..."
for i in $(seq 1 30); do
  if sqlcmd -S localhost -U sa -P 'Btk_Lab_2026!' -C -Q "SELECT 1" > /dev/null 2>&1; then
    echo "===== OTOMATIK KONTROL ====="
    sqlcmd -S localhost -U sa -P 'Btk_Lab_2026!' -C -Q "SELECT @@VERSION AS version" | head -5
    echo "PASS: SQL Server 2022 hazir. Baglanti: localhost,1433 / sa"
    exit 0
  fi
  sleep 3
done

echo "===== OTOMATIK KONTROL ====="
echo "FAIL: SQL Server 90 saniyede ayaga kalkmadi. 'docker logs' ciktisini kontrol et."
exit 1
