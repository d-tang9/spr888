#!/bin/bash

SEARCH_DIR="/home/dtang/Desktop/spr888/challenges/dickson/challenge2/files"

if [[ ! -d "$SEARCH_DIR" ]]; then
  echo "[!] Directory not found: $SEARCH_DIR"
  exit 1
fi

# Temporary storage for results
TMP_FILE=$(mktemp)

# Scan each file for FLAG_PART_X{...}
for file in "$SEARCH_DIR"/*; do
    grep -oP 'FLAG_PART_\d+\{\K[^}]+' "$file" 2>/dev/null | while read -r value; do
        part=$(grep -oP 'FLAG_PART_\d+' "$file" | grep -oP '\d+')
        if [[ $part =~ ^[0-9]+$ ]]; then
            echo "$part:$value" >> "$TMP_FILE"
        fi
    done
done

# Check results
if [[ ! -s "$TMP_FILE" ]]; then
    echo "[✗] No flag parts found."
    rm "$TMP_FILE"
    exit 1
fi

echo "[✓] Found flag parts:"
sort -n "$TMP_FILE" | uniq | while IFS=: read -r part value; do
    echo "Part $part = $value"
done

# Reconstruct the flag
FLAG=$(sort -n "$TMP_FILE" | uniq | cut -d: -f2 | tr -d '\n')
echo -e "\n🏁 Full Flag: FLAG{$FLAG}"

rm "$TMP_FILE"
