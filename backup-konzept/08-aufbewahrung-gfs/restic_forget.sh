#!/bin/bash
# Aufbewahrung mit restic: forget --dry-run zeigt, was gelöscht würde; erst --prune gibt Platz frei.
# Aufruf: bash restic_forget.sh [Arbeitsordner]
set -eu
W="${1:-./lab08}"; rm -rf "$W"; mkdir -p "$W/daten" && cd "$W"
echo "LabKennwort-nur-fuer-Uebung" > kennwort.txt
export RESTIC_REPOSITORY="$PWD/repo" RESTIC_PASSWORD_FILE="$PWD/kennwort.txt"
restic init -q
echo "== 40 tägliche Sicherungen ab 2026-01-01 anlegen (mit --time)"
for i in $(seq 0 39); do
  head -c 20000 /dev/urandom > daten/tag.bin
  T=$(date -d "2026-01-01 +$i days 03:00:00" '+%Y-%m-%d %H:%M:%S')
  restic backup -q --time "$T" daten
done
restic snapshots --compact | tail -n 3
echo "== Trockenlauf: 7 täglich, 4 wöchentlich, 1 monatlich"
restic forget --dry-run --keep-daily 7 --keep-weekly 4 --keep-monthly 1 | grep -v "^$"
echo "== Echt ausführen mit --prune"
restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 1 --prune -q
restic snapshots --compact | tail -n 4
restic check | tail -n 1
