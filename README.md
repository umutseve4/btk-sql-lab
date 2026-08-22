# btk-sql-lab

BTK Akademi SQL kursu için **GitHub Codespaces** üzerinde çalışan, gerçek
SQL Server 2022 kullanan eğitim laboratuvarı. Yerel SQL Server kurulumu gerekmez;
tarayıcıdan açılır ve otomatik bağlantı kontrolü yapar.

## Hızlı başlangıç

1. Yeşil **Code** düğmesi → **Codespaces** → **Create codespace on main**.
2. İlk kurulumun tamamlanmasını bekle (genellikle 3–5 dakika). Terminalde
   `===== OTOMATIK KONTROL =====` altında `PASS` görünmelidir.
3. Çalışma zamanını doğrula:

   ```bash
   sqlcmd -S localhost -U sa -P 'Btk_Lab_2026!' -C -b -V 16 \
     -i sql/00_smoke_test.sql
   ```

`BTK_SQL_SMOKE_OK` ve `btk` çıktıları görünüyorsa laboratuvar hazırdır.
VS Code içindeki **SQL Server (mssql)** eklentisinde hazır `btk-lab` bağlantı
profili de kullanılabilir.

## Otomatik kalite kapısı

Her pull request ve `main` push'unda GitHub Actions:

1. Shell betiklerinin sözdizimini doğrular.
2. Gerçek `mcr.microsoft.com/mssql/server:2022-latest` container'ını başlatır.
3. `sql/00_smoke_test.sql` dosyasını `-b -V 16` ile çalıştırır; SQL hataları işi düşürür.
4. `btk` veritabanının oluştuğunu sorguyla doğrular.
5. Yanlış parolanın reddedildiği failure-path testini çalıştırır.

## Yapı

```text
.devcontainer/              Codespace ve SQL Server tanımı
.github/workflows/          CI kalite kapısı
scripts/ci-sql-smoke.sh     Container tabanlı runtime doğrulaması
sql/                        Ders SQL dosyaları
SECURITY.md                 Güvenlik bildirim süreci
```

## Güvenlik modeli

`Btk_Lab_2026!`, yalnızca izole Codespace veritabanı için belgelenmiş ve sabit
bir geliştirme parolasıdır. Hazır VS Code bağlantı profili, `dev` servisi ve
SQL Server aynı değeri kullanır; böylece yapılandırma atomik kalır. Bu parola
gerçek sır değildir; ancak **başka hiçbir sistemde yeniden kullanılmamalı**,
internete açık veya üretim SQL Server'ında kullanılmamalıdır. CI, bu geliştirme
kimliğini kullanmaz; her çalışmada yeni ve loglarda maskelenmiş bir parola üretir.

Güvenlik açığı bildirmek için [SECURITY.md](SECURITY.md) dosyasını kullan.

## Veri kalıcılığı ve maliyet

- Veriler `mssql-data` volume'unda tutulur. Codespace durdurulup açıldığında
  korunur; Codespace silindiğinde kaybolur.
- Codespaces kotası ve fiyatlandırması değişebilir. Güncel limitleri
  [GitHub Codespaces billing documentation](https://docs.github.com/en/billing/managing-billing-for-your-products/managing-billing-for-github-codespaces/about-billing-for-github-codespaces)
  üzerinden doğrula ve işin bitince Codespace'i **Stop** et.

## Lisans

[MIT](LICENSE)
