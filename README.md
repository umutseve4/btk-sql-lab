# btk-sql-lab

BTK Akademi SQL kursu icin **GitHub Codespaces** uzerinde calisan SQL Server 2022 laboratuvari.
Eski bir bilgisayardan (or. Windows 7) bile sadece tarayici ile kullanilir — lokal kurulum gerekmez.

## Kullanim (3 adim)

1. Bu repoda yesil **Code** butonu → **Codespaces** sekmesi → **Create codespace on main**.
2. Ortam kurulumunun bitmesini bekle (ilk seferde ~3-5 dk). Terminalde `===== OTOMATIK KONTROL =====` altinda **PASS** gorunmeli.
3. Terminale su komutu yapistirip calistir:

   ```bash
   sqlcmd -S localhost -U sa -P 'Btk_Lab_2026!' -C -i sql/00_smoke_test.sql
   ```

   `sql_server_surumu` satirinda *Microsoft SQL Server 2022* goruyorsan lab hazirdir.

Alternatif: VS Code icindeki **SQL Server (mssql)** eklentisinde hazir `btk-lab` baglanti profili vardir — tikla, bagla, `.sql` dosyalarini oradan calistir.

## Yapi

```
.devcontainer/   Codespace tanimi (Ubuntu dev + SQL Server 2022 container)
sql/             Kurs boyunca yazilan SQL dosyalari (ders basina bir dosya onerilir)
```

## Notlar

- `sa` parolasi (`Btk_Lab_2026!`) **sadece gecici Codespace icindeki lokal veritabani** icindir; internete acik degildir ve sir sayilmaz.
- Codespaces ucretsiz kota: kisisel hesaplarda ayda 120 cekirdek-saat (2 cekirdekli makinede ~60 saat). Isin bitince Codespace'i **Stop** et.
- Veriler `mssql-data` volume'unda tutulur; Codespace durdurulup acilinca kaybolmaz, ancak Codespace **silinirse** kaybolur.
