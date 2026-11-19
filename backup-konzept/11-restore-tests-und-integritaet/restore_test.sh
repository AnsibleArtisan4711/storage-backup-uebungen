#!/bin/bash
# Restore-Test mit Prüfsummen und Fehlerbildern: sha256-Manifest, beschädigtes Repository, typische Rückgabewerte.
# Aufruf: bash restore_test.sh [Arbeitsordner]
set -u
W="${1:-./lab11}"; rm -rf "$W"; mkdir -p "$W/quelle/sub" && cd "$W"
echo "LabKennwort-nur-fuer-Uebung" > kennwort.txt
export RESTIC_REPOSITORY="$PWD/repo" RESTIC_PASSWORD_FILE="$PWD/kennwort.txt"
for i in $(seq 1 12); do head -c 30000 /dev/urandom > quelle/sub/f$i.bin; done
echo "== 1. Manifest vor der Sicherung"
( cd quelle && find . -type f -print0 | sort -z | xargs -0 sha256sum ) > manifest.sha256
wc -l < manifest.sha256
restic init -q; restic backup -q quelle
echo "== 2. Restore in neuen Ordner und Prüfung gegen das Manifest"
restic restore latest --target rest -q
ZD=$(find rest -type d -name quelle | head -n 1)
( cd "$ZD" && sha256sum -c "$OLDPWD/manifest.sha256" 2>&1 | grep -vc ': OK$' ) | sed 's/^/Abweichungen: /'
echo "== 3. restic check normal, dann mit --read-data"
restic check | tail -n 1
restic check --read-data | tail -n 1
echo "== 4. Ein Datenpaket im Repository beschädigen (1 Byte)"
P=$(ls -S repo/data/*/* | head -n 1)   # größtes Paket = Datenpaket
printf '\xff' | dd of="$P" bs=1 seek=200 conv=notrunc 2>/dev/null
restic check >/dev/null 2>&1; echo "check ohne --read-data: Rückgabewert $?"
restic check 2>&1 | tail -n 1
restic check --read-data 2>&1 | grep -E "Fatal|error|ciphertext|Pack" | head -n 4
restic check --read-data >/dev/null 2>&1; echo "check --read-data: Rückgabewert $?"
echo "== 5. Typische Rückgabewerte"
rsync -a /gibt/es/nicht/ x/ 2>/dev/null; echo "rsync Quelle fehlt: $?"
tar -cf t.tar quelle/sub/f1.bin quelle/sub/nicht.bin 2>/dev/null; echo "tar Datei fehlt: $?"
tar -cf t2.tar -C quelle sub; echo "tar ok: $?"
env -u RESTIC_PASSWORD_FILE RESTIC_PASSWORD=falsch restic snapshots >/dev/null 2>&1; echo "restic falsches Kennwort: $?"
restic -r "$PWD/gibtsnicht" snapshots >/dev/null 2>&1; echo "restic Repository fehlt: $?"
