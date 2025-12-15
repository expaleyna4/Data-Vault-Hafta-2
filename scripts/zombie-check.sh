#!/usr/bin/env bash
echo "[ZOMBIE SÜREÇ KONTROLÜ]"

ZOMBIES=$(ps aux | awk '$8 ~ /Z/ {print $0}')

if [ -z "$ZOMBIES" ]; then
  echo "Zombie süreç tespit edilmedi."
else
  echo "Aşağıdaki zombie süreçler bulundu:"
  echo "$ZOMBIES"
fi
