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
