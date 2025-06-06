#!/bin/bash

echo "-----[ Checking player account ]-----"
if id "ctfplayer" &>/dev/null; then
  echo "[+] User 'ctfplayer' exists"
else
  echo "[-] User 'ctfplayer' does not exist"
fi

echo "-----[ Checking docker group for user ]-----"
if groups ctfplayer | grep -q docker; then
  echo "[+] ctfplayer is in docker group"
else
  echo "[-] add ctfplayer to docker group"
fi

echo "-----[ Checking docker-compose ]-----"
FILE="/home/ctfplayer/docker-compose.yml"
if [ -e "$FILE" ]; then
  OWNER=$(stat -c '%U' "$FILE")
  PERMISSION=$(stat -c '%a' "$FILE")
  if [ "$OWNER" = "root" ] && [ "$PERMISSION" = "700" ]; then
    echo "[+] docker-compose tamper proof"
  else
    echo "[-] docker-compose needs new permission"]
  fi
else
  echo "[-] file does not exist"
fi

echo "-----[ Check services ]-----"
for services in ssh cron; do
  if systemctl is-enabled $services &>/dev/null; then
    echo "[-] $services is enabled"
  else
    echo "[+] $services is disabled"
  fi
done

echo "-----[ Check GRUB ]-----"
if grep -q 'set superusers=' /etc/grub.d/40_custom && grep -q 'password_pbkdf2' /etc/grub.d/40_custom; then
  echo "[+] GRUB password set"
else
  echo "[-] GRUB password missing"
fi

if grep -q 'GRUB_DISABLE_RECOVERY="true"' /etc/default/grub; then
  echo "[+] GRUB recovery mode is disabled"
else
  echo "[-] GRUB recovery mode is enabled"
fi

echo "-----[ Check Complete ]-----"
