#!/bin/bash
# Verschlüsselte, deduplizierende Sicherung mit restic: init, backup, snapshots, diff, stats, restore, check.
# Aufruf:  bash restic_demo.sh [Arbeitsordner]     (Standard ./lab07, wird neu angelegt)
# Das Kennwort ist ein Laborwert und steht in der Datei kennwort.txt im Arbeitsordner (nie ein echtes Kennwort verwenden).
set -eu
W="${1:-./lab07}"; rm -rf "$W"; mkdir -p "$W/daten/projekte" "$W/repo" && cd "$W"
echo "LabKennwort-nur-fuer-Uebung" > kennwort.txt; chmod 600 kennwort.txt
export RESTIC_REPOSITORY="$PWD/repo" RESTIC_PASSWORD_FILE="$PWD/kennwort.txt"
for i in $(seq 1 30); do head -c 51200 /dev/urandom > "daten/projekte/modell$i.bin"; done
echo "Beispieltext" > daten/notiz.txt
echo "== restic init"; restic init
echo "== Sicherung 1"; restic backup --tag lab daten | tail -n 6
sleep 1
echo "== 3 Dateien geändert, 1 neue; Sicherung 2"
for i in 1 2 3; do head -c 51200 /dev/urandom > "daten/projekte/modell$i.bin"; done
head -c 51200 /dev/urandom > daten/projekte/modell31.bin
restic backup --tag lab daten | tail -n 6
echo "== Sicherung 3 ohne Änderung (alles bereits vorhanden)"; restic backup --tag lab daten | tail -n 6
echo "== snapshots"; restic snapshots
echo "== diff zwischen Sicherung 1 und 2"
ID1=$(restic snapshots --json | python3 -c 'import json,sys; print(json.load(sys.stdin)[0]["short_id"])')
ID2=$(restic snapshots --json | python3 -c 'import json,sys; print(json.load(sys.stdin)[1]["short_id"])')
restic diff "$ID1" "$ID2" | tail -n 12
echo "== stats (Wiederherstellungsgröße und Platzbedarf im Repository)"
restic stats --mode restore-size latest
restic stats --mode raw-data
echo "== Dateien im Repository: Aufbau"; ls repo; find repo/data -type f | wc -l
echo "== Wiederherstellung der letzten Sicherung nach ziel/ und Vergleich"
restic restore latest --target ziel | tail -n 2
( cd daten && find . -type f -print0 | sort -z | xargs -0 sha256sum ) > soll.sha
ZD=$(find ziel -type d -name daten | head -n 1)   # Lage unter dem Ziel hängt von der restic-Version ab
( cd "$ZD" && find . -type f -print0 | sort -z | xargs -0 sha256sum ) > ist.sha
cmp soll.sha ist.sha && echo "Wiederherstellung identisch mit dem Original"
echo "== Falsches Kennwort"
env -u RESTIC_PASSWORD_FILE RESTIC_PASSWORD=falsch restic snapshots 2>&1 | tail -n 2 || true
echo "== check"; restic check
