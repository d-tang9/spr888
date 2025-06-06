#!/bin/bash

SEARCH_DIR="/home/dtang/Desktop/spr888/challenges/dickson/challenge2/files"

if [[ ! -d "$SEARCH_DIR" ]]; then
  echo "[!] Directory not found: $SEARCH_DIR"
  exit 1
fi

TMP_FILE=$(mktemp)

echo "[*] Scanning for flag fragments..."

# Match full pattern like: FLAG_PART_3{a}
for file in "$SEARCH_DIR"/*; do
  grep -aPo 'FLAG_PART_\d+\{[^}]+\}' "$file" 2>/dev/null | while read -r match; do
    part_num=$(echo "$match" | grep -oP 'FLAG_PART_\K\d+')
    char=$(echo "$match" | grep -oP '\{[^}]+\}' | tr -d '{}')
    echo "$part_num:$char" >> "$TMP_FILE"
  done
done

if [[ ! -s "$TMP_FILE" ]]; then
  echo "[✗] No flag fragments found."
  rm "$TMP_FILE"
  exit 1
fi

echo "[✓] Found flag parts:"
sort -n "$TMP_FILE" | uniq | while IFS=: read -r part char; do
  echo "Part $part = $char"
done

# Reconstruct the flag
FLAG=$(sort -n "$TMP_FILE" | uniq | cut -d: -f2 | tr -d '\n')
echo -e "\n🏁 Full Flag: FLAG{$FLAG}"

rm "$TMP_FILE"
