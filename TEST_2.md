# Hafta 2 Test Senaryoları

## Hızlı Test
```bash
# Tüm testleri sırayla çalıştır
cd /opt/data-vault
sudo ./zombie-check.sh
sudo ./disk-rapor.sh
sudo ./departman-ozet.sh

# Çıktıları kontrol
sudo cat /var/log/disk-rapor-$(date +%Y%m%d).txt | head -n 20
cat /var/log/departman-ozet.csv
```

## Test 1: Dizin Yapısı
```bash
tree /data -L 2 || ls -lR /data
# Beklenen: finans, ik, muhasebe, arge + test dosyaları
```

## Test 2: Büyük Dosyalar
```bash
ls -lh /data/departmanlar/*/2024* /data/departmanlar/*/personel* /data/departmanlar/*/rapor*
# Beklenen: 1G, 800M, 600M
```

## Test 3: Zombie Kontrol
```bash
sudo /opt/data-vault/zombie-check.sh
# Beklenen: "Zombie süreç tespit edilmedi."
```

## Test 4: Disk Raporu
```bash
sudo /opt/data-vault/disk-rapor.sh
sudo cat /var/log/disk-rapor-$(date +%Y%m%d).txt
# Beklenen: 3GB toplam, departman detayları, en büyük dosyalar
```

## Test 5: CSV Özet
```bash
sudo /opt/data-vault/departman-ozet.sh
cat /var/log/departman-ozet.csv
# Beklenen: departman;boyut_gb;durum formatı
```

## Test 6: CPU/RAM
```bash
ps aux --sort=-%cpu | head -n 10
ps aux --sort=-%mem | head -n 10
# Beklenen: Sıralı liste
```

## Otomatik Test Script'i
```bash
#!/bin/bash
echo "=== HAFTA 2 TEST ==="

# Test 1
echo "[1] Zombie Kontrol"
sudo /opt/data-vault/zombie-check.sh

# Test 2
echo "[2] Disk Raporu"
sudo /opt/data-vault/disk-rapor.sh
[ -f /var/log/disk-rapor-$(date +%Y%m%d).txt ] && echo "✓ Rapor oluşturuldu"

# Test 3
echo "[3] CSV Özet"
sudo /opt/data-vault/departman-ozet.sh
[ -f /var/log/departman-ozet.csv ] && echo "✓ CSV oluşturuldu"

# Test 4
echo "[4] Dosya Boyutları"
du -sh /data/departmanlar/*

echo "=== TEST TAMAMLANDI ==="
```

## Beklenen Sonuçlar

### Disk Raporu
```
=== DATA VAULT – DISK RAPORU ===

[1] Departman Boyutları:
3G  /data/departmanlar
2G  /data/departmanlar/finans
1G  /data/departmanlar/muhasebe
1G  /data/departmanlar/ik

[2] En Büyük Dosyalar:
1024.00 MB  /data/departmanlar/finans/2024-yillik.xlsx
800.00 MB   /data/departmanlar/ik/personel-arsiv.zip
600.00 MB   /data/departmanlar/muhasebe/rapor1.bin
```

### CSV Özet
```csv
departman;boyut_gb;durum
finans;2;NORMAL
muhasebe;1;NORMAL
ik;1;NORMAL
```
