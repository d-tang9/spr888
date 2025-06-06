#!/bin/bash

ZIPFILE="$1"
WORDLIST="$2"

if [[ -z "$ZIPFILE" || -z "$WORDLIST" ]]; then
  echo "Provide zipfile and wordlist"
  exit 1
fi

while read -r PASSWORD; do
  echo "-----[ Trying password $PASSWORD ]-----"
  unzip -P "$PASSWORD" "$ZIPFILE" > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "[+] Password found: $PASSWORD"
    exit 0
  fi
done < "$WORDLIST"

echo "[-] Password not found"
