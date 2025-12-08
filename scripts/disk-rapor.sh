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
