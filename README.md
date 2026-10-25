SQLmap: Check for SQL injection vulnerabilities using active session cookies.

John the Ripper: Seamlessly hash crack wordlists.

Hydra: Simulate brute-force attacks against web-based login forms.

ez LOLL

all need 
tools 

John the ripper

SQLmap

hydra


# DVWA Auto Pwn Chain - From SQLi to Brute

Full automation for DVWA local lab:
Login -> Set Low Security -> Dump DB -> Crack Hash -> Brute Login

## How It Works

1. Auto Login
Get PHPSESSID via curl login to /login.php
Save cookie, extract PHPSESSID

2. Set Security Low
Request security.php?security=low to enable vulnerable mode

3. Dumping [1]
sqlmap -u /vulnerabilities/sqli/?id=1 --dbs --batch
Test connection and cookie, then enumerate databases

4. Cracking [2]
john hash.txt --wordlist=cracked.txt --format=Raw-MD5
Clear old john.pot for clean result

5. Brute Force [3]
hydra -l admin -P cracked.txt http-form-post /vulnerabilities/brute/
Final stage to prove cracked password works on login form

## Requirements

- DVWA running on http://127.0.0.1:8000
- Tools: sqlmap, john the ripper, hydra
- Files: hash.txt, cracked.txt

## Usage

chmod +x auto_pwn.sh
./auto_pwn.sh

## Output Example

[+] Got PHPSESSID: abc123
[OK] Security set to low
[1] dumping...
[2] cracking...
[3] brute...

## Disclaimer

For educational lab use only. DVWA is intentional vulnerable app.
Do not use on real targets without permission.


