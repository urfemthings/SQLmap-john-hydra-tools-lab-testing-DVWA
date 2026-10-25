# WRITE-UP: DVWA Full Chain

Target: DVWA low security local lab

Chain Logic:
sqli -> hash dump -> john crack -> hydra brute

1. Kenapa mulai dari sqli?
Karena di low, id=1 vulnerable. sqlmap bisa dump users table.
Di dalemnya ada hash MD5 password.

2. Kenapa john?
Hash MD5 itu gak bisa di-reverse, harus di-crack pake wordlist.
john + Raw-MD5 format paling cepet buat DVWA hash.

3. Kenapa hydra terakhir?
Setelah dapet password plain dari john, kita buktikan password itu valid di form lain yaitu brute/index.php.
Ini nunjukin password reuse, yang sering kejadian di real world.

Impact:
Dari satu vuln sqli, kita bisa takeover akun admin full.

Lesson:
Jangan pernah simpen password pake MD5 tanpa salt, dan jangan reuse password.