#!/bin/bash
# DATA VAULT - HAFTA 2 - Otomatik Test Scripti
# Disk Analizi ve Metin İşleme Testleri

echo "======================================"
echo "  DATA VAULT - HAFTA 2 TEST"
echo "======================================"
echo ""
echo "⏱️  Test başlıyor..."
echo ""
sleep 1

# Test sayaçları
PASSED=0
FAILED=0

# Test fonksiyonu
test_check() {
    if [ $? -eq 0 ]; then
        echo "  ✅ BAŞARILI"
        ((PASSED++))
    else
        echo "  ❌ BAŞARISIZ"
        ((FAILED++))
    fi
    echo ""
    read -p "Sonraki teste geçmek için Enter'a basın..." dummy
    echo ""
}

# Test 1: Departman dizinleri
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "[TEST 1/12] Departman Dizinleri"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "# Amaç: /data/departmanlar altında 4 departman klasörünün varlığını doğrula"
echo ""
echo "➤ Çalıştırılan Komut:"
echo "  ls -ld /data/departmanlar/*/"
echo ""
echo "➤ Yanıt:"
ls -ld /data/departmanlar/*/ 2>&1
echo ""
echo "# Açıklama: finans, ik, muhasebe, arge klasörleri mevcut mu?"
[ -d /data/departmanlar/finans ] && [ -d /data/departmanlar/ik ] && \
[ -d /data/departmanlar/muhasebe ] && [ -d /data/departmanlar/arge ]
test_check

# Test 2: Büyük dosyalar
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "[TEST 2/12] Büyük Test Dosyaları"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "# Amaç: fallocate ile oluşturulan büyük test dosyalarının boyutlarını kontrol et"
echo "# fallocate: Disk alanı ayırır ama gerçek veri yazmaz (hızlı dosya oluşturma)"
echo ""
echo "➤ Çalıştırılan Komut:"
echo "  ls -lh /data/departmanlar/finans/2024-yillik.xlsx"
echo "  ls -lh /data/departmanlar/ik/personel-arsiv.zip"
echo "  ls -lh /data/departmanlar/muhasebe/rapor1.bin"
echo ""
echo "➤ Yanıt:"
ls -lh /data/departmanlar/finans/2024-yillik.xlsx 2>&1
ls -lh /data/departmanlar/ik/personel-arsiv.zip 2>&1
ls -lh /data/departmanlar/muhasebe/rapor1.bin 2>&1
echo ""
F1_SIZE=$(stat -c %s /data/departmanlar/finans/2024-yillik.xlsx 2>/dev/null || echo 0)
F2_SIZE=$(stat -c %s /data/departmanlar/ik/personel-arsiv.zip 2>/dev/null || echo 0)
F3_SIZE=$(stat -c %s /data/departmanlar/muhasebe/rapor1.bin 2>/dev/null || echo 0)
echo "# Dosya boyutları (MB):"
echo "  finans/2024-yillik.xlsx: $((F1_SIZE/1024/1024)) MB (beklenen: ~1024 MB)"
echo "  ik/personel-arsiv.zip: $((F2_SIZE/1024/1024)) MB (beklenen: ~800 MB)"
echo "  muhasebe/rapor1.bin: $((F3_SIZE/1024/1024)) MB (beklenen: ~600 MB)"
echo ""
echo "# Açıklama: Dosyalar beklenen boyutlarda mı?"
[ $F1_SIZE -gt 1000000000 ] && [ $F2_SIZE -gt 700000000 ] && [ $F3_SIZE -gt 500000000 ]
test_check

# Test 3: tmp/cache klasörleri
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "[TEST 3/12] tmp/cache Klasörleri"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "# Amaç: Geçici dosyalar için tmp ve cache klasörlerinin varlığını kontrol et"
echo "# Bu klasörler disk raporlarında --exclude ile hariç tutulacak"
echo ""
echo "➤ Çalıştırılan Komut:"
echo "  ls -la /data/departmanlar/finans/ | grep -E 'tmp|cache'"
echo "  ls -la /data/departmanlar/ik/ | grep -E 'tmp|cache'"
echo ""
echo "➤ Yanıt:"
ls -la /data/departmanlar/finans/ 2>&1 | grep -E "tmp|cache"
ls -la /data/departmanlar/ik/ 2>&1 | grep -E "tmp|cache"
echo ""
echo "# Açıklama: tmp ve cache klasörleri her iki departmanda da var mı?"
[ -d /data/departmanlar/finans/tmp ] && [ -d /data/departmanlar/finans/cache ] && \
[ -d /data/departmanlar/ik/tmp ] && [ -d /data/departmanlar/ik/cache ]
test_check

# Test 4: Script dizini
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "[TEST 4/12] Script Dizini"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "# Amaç: /opt/data-vault dizininin varlığını kontrol et"
echo ""
echo "➤ Çalıştırılan Komut:"
echo "  ls -lh /opt/data-vault/"
echo ""
echo "➤ Yanıt:"
ls -lh /opt/data-vault/ 2>&1
echo ""
echo "# Açıklama: Script'ler /opt altında merkezi konumda"
[ -d /opt/data-vault ]
test_check

# Test 5: zombie-check.sh varlığı
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "[TEST 5/12] zombie-check.sh Varlığı"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "# Amaç: Zombie süreç kontrolü scriptinin var ve çalıştırılabilir olduğunu doğrula"
echo "# Zombie süreç: Parent süreç ölen ama temizlenmeyen child süreçler (Z durumu)"
echo ""
echo "➤ Çalıştırılan Komut:"
echo "  ls -l /opt/data-vault/zombie-check.sh"
echo ""
echo "➤ Yanıt:"
ls -l /opt/data-vault/zombie-check.sh 2>&1
echo ""
echo "# Açıklama: Execute (x) izni var mı?"
[ -x /opt/data-vault/zombie-check.sh ]
test_check

# Test 6: zombie-check.sh çalıştırma
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "[TEST 6/12] zombie-check.sh Çalıştırma"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "# Amaç: Script çalıştığında zombie süreç tespiti yapabilmeli"
echo "# İçerik: ps aux | awk '\$8 ~ /Z/'"
echo ""
echo "➤ Çalıştırılan Komut:"
echo "  sudo /opt/data-vault/zombie-check.sh"
echo ""
echo "➤ Yanıt:"
sudo /opt/data-vault/zombie-check.sh 2>&1
echo ""
echo "# Açıklama: Script hatasız çalıştı mı?"
sudo /opt/data-vault/zombie-check.sh >/dev/null 2>&1
test_check

# Test 7: disk-rapor.sh varlığı
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "[TEST 7/12] disk-rapor.sh Varlığı"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "# Amaç: Disk analiz scriptinin varlığını kontrol et"
echo ""
echo "➤ Çalıştırılan Komut:"
echo "  ls -l /opt/data-vault/disk-rapor.sh"
echo ""
echo "➤ Yanıt:"
ls -l /opt/data-vault/disk-rapor.sh 2>&1
echo ""
echo "# Açıklama: Script çalıştırılabilir mi?"
[ -x /opt/data-vault/disk-rapor.sh ]
test_check

# Test 8: disk-rapor.sh çalıştırma
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "[TEST 8/12] disk-rapor.sh Çalıştırma"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "# Amaç: Disk kullanım raporunu oluştur ve /var/log'a kaydet"
echo "# Kullanılan komutlar: du -BG, find -printf, awk, sort"
echo ""
echo "➤ Çalıştırılan Komut:"
echo "  sudo /opt/data-vault/disk-rapor.sh"
echo ""
echo "➤ Yanıt:"
sudo /opt/data-vault/disk-rapor.sh 2>&1
echo ""
REPORT_FILE="/var/log/disk-rapor-$(date +%Y%m%d).txt"
echo "# Açıklama: Rapor dosyası oluşturuldu mu?"
echo "  Beklenen dosya: $REPORT_FILE"
[ -f "$REPORT_FILE" ]
if [ $? -eq 0 ]; then
    echo ""
    echo "➤ Rapor İçeriği (ilk 20 satır):"
    sudo head -n 20 "$REPORT_FILE" 2>&1
    test_check
else
    echo "  ❌ Rapor dosyası bulunamadı"
    ((FAILED++))
    echo ""
    read -p "Sonraki teste geçmek için Enter'a basın..." dummy
    echo ""
fi

# Test 9: departman-ozet.sh varlığı
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "[TEST 9/12] departman-ozet.sh Varlığı"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "# Amaç: CSV özet scriptinin varlığını kontrol et"
echo ""
echo "➤ Çalıştırılan Komut:"
echo "  ls -l /opt/data-vault/departman-ozet.sh"
echo ""
echo "➤ Yanıt:"
ls -l /opt/data-vault/departman-ozet.sh 2>&1
echo ""
echo "# Açıklama: Script çalıştırılabilir mi?"
[ -x /opt/data-vault/departman-ozet.sh ]
test_check

# Test 10: departman-ozet.sh çalıştırma
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "[TEST 10/12] departman-ozet.sh Çalıştırma"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "# Amaç: Departman boyutlarını CSV formatında özetle"
echo "# AWK ile metin işleme: Boyut >= 50GB ise 'UYARI', değilse 'NORMAL'"
echo "# Format: departman;boyut_gb;durum"
echo ""
echo "➤ Çalıştırılan Komut:"
echo "  sudo /opt/data-vault/departman-ozet.sh"
echo ""
echo "➤ Yanıt:"
sudo /opt/data-vault/departman-ozet.sh 2>&1
echo ""
CSV_FILE="/var/log/departman-ozet.csv"
echo "# Açıklama: CSV dosyası oluşturuldu mu?"
echo "  Beklenen dosya: $CSV_FILE"
[ -f "$CSV_FILE" ]
if [ $? -eq 0 ]; then
    echo ""
    echo "➤ CSV İçeriği:"
    cat "$CSV_FILE" 2>&1
    test_check
else
    echo "  ❌ CSV dosyası bulunamadı"
    ((FAILED++))
    echo ""
    read -p "Sonraki teste geçmek için Enter'a basın..." dummy
    echo ""
fi

# Test 11: Rapor içeriği kontrolü
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "[TEST 11/12] Disk Raporu İçerik Kontrolü"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "# Amaç: Rapor dosyasında beklenen başlıklar ve içerik var mı?"
echo ""
if [ -f "$REPORT_FILE" ]; then
    echo "➤ Çalıştırılan Komut:"
    echo "  grep -E 'departmanlar|En Büyük' $REPORT_FILE"
    echo ""
    echo "➤ Yanıt:"
    grep -E "departmanlar|En Büyük" "$REPORT_FILE" 2>&1 | head -n 5
    echo ""
    echo "# Açıklama: 'departmanlar' ve 'En Büyük' başlıkları var mı?"
    grep -q "departmanlar" "$REPORT_FILE" && grep -q "En Büyük" "$REPORT_FILE"
    test_check
else
    echo "  ⚠️  Rapor dosyası yok, test atlandı"
    echo ""
    read -p "Sonraki teste geçmek için Enter'a basın..." dummy
    echo ""
fi

# Test 12: CSV formatı kontrolü
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "[TEST 12/12] CSV Format Kontrolü"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "# Amaç: CSV başlık satırı doğru formatta mı?"
echo "# Beklenen format: departman;boyut_gb;durum"
echo ""
if [ -f "$CSV_FILE" ]; then
    echo "➤ Çalıştırılan Komut:"
    echo "  head -n 1 $CSV_FILE"
    echo ""
    echo "➤ Yanıt:"
    head -n 1 "$CSV_FILE" 2>&1
    echo ""
    echo "# Açıklama: Başlık satırı 'departman;boyut_gb;durum' içeriyor mu?"
    grep -q "departman;boyut_gb;durum" "$CSV_FILE"
    test_check
else
    echo "  ⚠️  CSV dosyası yok, test atlandı"
    echo ""
    read -p "Sonraki teste geçmek için Enter'a basın..." dummy
    echo ""
fi

# Özet rapor
echo "======================================"
echo "         TEST SONUÇLARI"
echo "======================================"
echo ""
echo "  ✅ Başarılı: $PASSED"
echo "  ❌ Başarısız: $FAILED"
echo "  📊 Toplam: $((PASSED + FAILED))"
echo ""

if [ $FAILED -eq 0 ]; then
    echo "🎉 TÜM TESTLER BAŞARILI!"
    echo ""
    echo "📊 Sistem Durumu:"
    echo "  Departmanlar: 4 adet (finans, ik, muhasebe, arge)"
    echo "  Test Dosyalar: 3 adet (toplam ~2.4GB)"
    echo "  Script'ler: 3 adet (/opt/data-vault/)"
    echo ""
    echo "📁 Dizin Boyutları:"
    du -sh /data/departmanlar/* 2>/dev/null || echo "  (du komutu çalıştırılamadı)"
    echo ""
    echo "📄 Son Oluşturulan Raporlar:"
    echo "  Disk Raporu: $REPORT_FILE"
    echo "  CSV Özet: $CSV_FILE"
else
    echo "⚠️  BAZI TESTLER BAŞARISIZ!"
    echo ""
    echo "Sorun giderme için:"
    echo "  bash ~/kurulum-hafta2.sh"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
read -p "Çıkmak için Enter'a basın..." dummy
