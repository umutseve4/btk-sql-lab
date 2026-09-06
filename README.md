<h1 align="center">btk-sql-lab</h1>

<p align="center">
  Gerçek bir SQL Server 2022 laboratuvarı, kurulum yok:<br>
  tarayıcıdan bir Codespace aç, 3–5 dakika bekle, terminalde <b><code>PASS</code></b> gör.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/kurulum%20s%C3%BCresi-3%E2%80%935%20dakika-FF4D4F?style=flat-square" alt="3-5 dakika">
  <img src="https://img.shields.io/badge/yerel%20kurulum-0%20ad%C4%B1m-FF4D4F?style=flat-square" alt="0 adım">
  <img src="https://img.shields.io/badge/CI%20kap%C4%B1s%C4%B1-5%20kontrol-FF4D4F?style=flat-square" alt="5 kontrol">
</p>

---

## 30 saniyede ne oluyor?

1. Yeşil **Code** düğmesi → **Codespaces** → **Create codespace on main**.
2. İlk kurulumun tamamlanmasını bekle (genellikle 3–5 dakika). Terminalde `===== OTOMATIK KONTROL =====` altında `PASS` görünmelidir.
3. Çalışma zamanını doğrula:

```bash
sqlcmd -S localhost -U sa -P 'Btk_Lab_2026!' -C -b -V 16 \
  -i sql/00_smoke_test.sql
```

`BTK_SQL_SMOKE_OK` ve `btk` çıktıları görünüyorsa laboratuvar hazırdır. VS Code
içindeki **SQL Server (mssql)** eklentisinde hazır `btk-lab` bağlantı profili de
kullanılabilir.

## Her push'ta ne doğrulanıyor?

Her pull request ve `main` push'unda GitHub Actions:

| # | Kontrol |
|---|---|
| 1 | Shell betiklerinin sözdizimini doğrular |
| 2 | Gerçek `mcr.microsoft.com/mssql/server:2022-latest` container'ını başlatır |
| 3 | `sql/00_smoke_test.sql` dosyasını `-b -V 16` ile çalıştırır; SQL hataları işi düşürür |
| 4 | `btk` veritabanının oluştuğunu sorguyla doğrular |
| 5 | Yanlış parolanın reddedildiği failure-path testini çalıştırır |

```text
.devcontainer/              Codespace ve SQL Server tanımı
.github/workflows/          CI kalite kapısı
scripts/ci-sql-smoke.sh     Container tabanlı runtime doğrulaması
sql/                        Ders SQL dosyaları
SECURITY.md                 Güvenlik bildirim süreci
```

## Sınırlar

- **Parola gerçek sır değildir, ama yine de yalnızca buraya aittir.** `Btk_Lab_2026!` yalnızca izole Codespace veritabanı için belgelenmiş ve sabit bir geliştirme parolasıdır. Hazır VS Code bağlantı profili, `dev` servisi ve SQL Server aynı değeri kullanır; böylece yapılandırma atomik kalır. **Başka hiçbir sistemde yeniden kullanılmamalı**, internete açık veya üretim SQL Server'ında kullanılmamalıdır. CI bu geliştirme kimliğini kullanmaz; her çalışmada yeni ve loglarda maskelenmiş bir parola üretir.
- **Veri kalıcılığı Codespace'e bağlıdır.** Veriler `mssql-data` volume'unda tutulur. Codespace durdurulup açıldığında korunur; **Codespace silindiğinde kaybolur**.
- **Maliyet senin kotandan çıkar.** Codespaces kotası ve fiyatlandırması değişebilir. Güncel limitleri [GitHub Codespaces billing documentation](https://docs.github.com/en/billing/managing-billing-for-your-products/managing-billing-for-github-codespaces/about-billing-for-github-codespaces) üzerinden doğrula ve iş bitince Codespace'i **Stop** et.

Güvenlik açığı bildirmek için [SECURITY.md](SECURITY.md) dosyasını kullan.

---

BTK Akademi SQL kursunu takip ederken en çok zaman kaybettiren adım kurulumdur; bu depo o adımı tamamen ortadan kaldırır.

Lisans: [MIT](LICENSE)
