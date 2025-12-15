#!/bin/bash
# DATA VAULT - HAFTA 2 - Otomatik Kurulum Scripti
# Disk Analizi ve Metin İşleme

set -e  # Hata durumunda dur

echo "======================================"
echo "  DATA VAULT - HAFTA 2 KURULUM"
echo "======================================"
echo ""
echo "⚠️  ÖNEMLİ: Hafta 1 kurulu olmalı!"
echo "   (Git ve temel yapı gerekli)"
echo ""
read -p "Devam edilsin mi? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "İptal edildi."
    exit 1
fi

# Kullanıcı bilgisi
echo "[1/5] Kullanıcı bilgisi..."
CURRENT_USER=$(whoami)
echo "  → Kullanıcı: $CURRENT_USER"
sleep 1

# Departman klasörleri
echo ""
echo "[2/5] Departman klasörleri oluşturuluyor..."
sudo mkdir -p /data/departmanlar/{finans,ik,muhasebe,arge}

# Büyük test dosyaları
echo "  → Büyük test dosyaları (1GB, 800MB, 600MB)..."
sudo fallocate -l 1G   /data/departmanlar/finans/2024-yillik.xlsx
sudo fallocate -l 800M /data/departmanlar/ik/personel-arsiv.zip
sudo fallocate -l 600M /data/departmanlar/muhasebe/rapor1.bin

# tmp/cache klasörleri
sudo mkdir -p /data/departmanlar/finans/{tmp,cache}
sudo mkdir -p /data/departmanlar/ik/{tmp,cache}

echo "  ✓ /data/departmanlar hazır (4 departman)"
sleep 1

# Script dizini
echo ""
echo "[3/5] Script dizini oluşturuluyor..."
sudo mkdir -p /opt/data-vault
echo "  ✓ /opt/data-vault hazır"
sleep 1

# Script'leri oluştur
echo ""
echo "[4/5] Script'ler yazılıyor..."

# zombie-check.sh
sudo tee /opt/data-vault/zombie-check.sh > /dev/null << 'EOF'
#!/usr/bin/env bash
echo "[ZOMBIE SÜREÇ KONTROLÜ]"

ZOMBIES=$(ps aux | awk '$8 ~ /Z/ {print $0}')

if [ -z "$ZOMBIES" ]; then
  echo "Zombie süreç tespit edilmedi."
else
  echo "Aşağıdaki zombie süreçler bulundu:"
  echo "$ZOMBIES"
fi
EOF

# disk-rapor.sh
sudo tee /opt/data-vault/disk-rapor.sh > /dev/null << 'EOF'
#!/usr/bin/env bash
# DATA VAULT – Disk Analizi Raporu

BASE="/data/departmanlar"
OUT="/var/log/disk-rapor-$(date +%Y%m%d).txt"

{
  echo "=== DATA VAULT – DISK RAPORU ($(date)) ==="
  echo
  echo "[1] Departman Dizini Boyutları (GB):"
  du -BG "$BASE" \
    --exclude="*/tmp" \
    --exclude="*/cache" \
    --exclude="*/backup-old" \
    2>/dev/null \
  | sort -nr | head -n 15

  echo
  echo "[2] En Büyük 20 Dosya (boyut + path):"
  find "$BASE" -type f -printf "%s %p\n" 2>/dev/null \
    | sort -nr | head -n 20 \
    | awk '{size=$1/1024/1024; printf "%.2f MB\t%s\n", size,$2}'
} > "$OUT"

echo "Rapor oluşturuldu: $OUT"
EOF

# departman-ozet.sh
sudo tee /opt/data-vault/departman-ozet.sh > /dev/null << 'EOF'
#!/usr/bin/env bash
BASE="/data/departmanlar"
OUT="/var/log/departman-ozet.csv"

du -BG "$BASE"/* \
  --exclude="*/tmp" \
  --exclude="*/cache" \
  2>/dev/null \
| sort -nr \
| awk 'BEGIN {
         print "departman;boyut_gb;durum"
       }
       {
         size_gb=$1
         gsub("G","",size_gb)
         split($2, pathParts, "/")
         dept=pathParts[length(pathParts)]
         status = (size_gb >= 50) ? "UYARI" : "NORMAL"
         print dept ";" size_gb ";" status
       }' > "$OUT"

echo "CSV oluşturuldu: $OUT"
EOF

# Çalıştırılabilir yap
sudo chmod +x /opt/data-vault/*.sh

echo "  ✓ 3 script hazır: zombie-check, disk-rapor, departman-ozet"
sleep 1

# Git'e ekle
echo ""
echo "[5/5] Git repository'ye ekleniyor..."
if [ -d ~/data-vault/.git ]; then
    cp /opt/data-vault/*.sh ~/data-vault/scripts/
    cd ~/data-vault
    git add scripts/*.sh
    git commit -m "feat: hafta 2 disk analizi ve metin işleme scriptleri eklendi"
    echo "  ✓ Git commit yapıldı"
else
    echo "  ⚠️  Git repo bulunamadı (~/data-vault)"
    echo "  → Script'ler /opt/data-vault/ içinde kullanılabilir"
fi
sleep 1

# Test çalıştır
echo ""
echo "======================================"
echo "  KURULUM TAMAMLANDI!"
echo "======================================"
echo ""
echo "📊 ÖZET:"
echo "  Departmanlar: finans, ik, muhasebe, arge"
echo "  Test Dosyalar: 1GB + 800MB + 600MB"
echo "  Script'ler:   /opt/data-vault/"
echo ""
echo "🧪 TEST KOMUTLARI:"
echo "  sudo /opt/data-vault/zombie-check.sh"
echo "  sudo /opt/data-vault/disk-rapor.sh"
echo "  sudo /opt/data-vault/departman-ozet.sh"
echo ""
echo "📁 ÇIKTILAR:"
echo "  /var/log/disk-rapor-YYYYMMDD.txt"
echo "  /var/log/departman-ozet.csv"
echo ""

# Hızlı test
echo "🚀 Hızlı test çalıştırılıyor..."
echo ""
sudo /opt/data-vault/zombie-check.sh
echo ""
sudo /opt/data-vault/disk-rapor.sh
sudo /opt/data-vault/departman-ozet.sh
echo ""
echo "📄 Disk Raporu (ilk 15 satır):"
sudo head -n 15 /var/log/disk-rapor-$(date +%Y%m%d).txt
echo ""
echo "📄 CSV Özet:"
cat /var/log/departman-ozet.csv
echo ""
echo "✅ Sistem hazır ve test edildi!"
