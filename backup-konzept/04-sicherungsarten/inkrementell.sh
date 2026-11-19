#!/bin/bash
# Zeigt voll, inkrementell und differenziell mit GNU tar (--listed-incremental) an echten Dateien.
# Aufruf:  bash inkrementell.sh [Arbeitsordner]      (Standard: ./lab04, wird neu angelegt)
# Nur im Übungsordner ausführen; der Arbeitsordner wird gelöscht und neu erstellt.
set -eu
W="${1:-./lab04}"
case "$W" in /|/home|/home/*|/root|/etc|/usr|/var) [ "$W" = "./lab04" ] || { echo "Arbeitsordner nicht erlaubt: $W"; exit 2; } ;; esac
rm -rf "$W"; mkdir -p "$W/daten" "$W/sicherung"
cd "$W"
# Tag 0: 200 Dateien zu je 10 kB
for i in $(seq 1 200); do head -c 10240 /dev/urandom > "daten/datei$i.bin"; done
echo "== Tag 0: Vollsicherung (Stufe 0)"
tar --create --gzip --listed-incremental=sicherung/voll.snar --file=sicherung/tag0-voll.tar.gz daten
cp sicherung/voll.snar sicherung/diff-basis.snar
# Tag 1: 10 Dateien ändern, 2 neue
sleep 1
for i in $(seq 1 10); do head -c 10240 /dev/urandom > "daten/datei$i.bin"; done
for i in 201 202; do head -c 10240 /dev/urandom > "daten/datei$i.bin"; done
echo "== Tag 1: inkrementell (Stufe 1 auf Stand von Tag 0) und differenziell (gegen Voll)"
tar --create --gzip --listed-incremental=sicherung/voll.snar --file=sicherung/tag1-inkr.tar.gz daten
cp sicherung/diff-basis.snar sicherung/diff.snar
tar --create --gzip --listed-incremental=sicherung/diff.snar --file=sicherung/tag1-diff.tar.gz daten
# Tag 2: weitere 10 Dateien ändern, eine löschen
sleep 1
for i in $(seq 11 20); do head -c 10240 /dev/urandom > "daten/datei$i.bin"; done
rm daten/datei100.bin
echo "== Tag 2: inkrementell und differenziell"
tar --create --gzip --listed-incremental=sicherung/voll.snar --file=sicherung/tag2-inkr.tar.gz daten
cp sicherung/diff-basis.snar sicherung/diff.snar
tar --create --gzip --listed-incremental=sicherung/diff.snar --file=sicherung/tag2-diff.tar.gz daten
echo
echo "== Größen der Sicherungsdateien (Bytes)"
ls -l sicherung/*.tar.gz | awk '{print $5, $9}'
echo
echo "== Dateien je Archiv"
for f in sicherung/tag*.tar.gz; do printf '%s: ' "$f"; tar --list --gzip --file="$f" | grep -c '\.bin$' || true; done
echo
echo "== Wiederherstellung Tag 2 über die Kette Voll + Inkrementell + Inkrementell"
mkdir -p ziel-inkr
for f in tag0-voll tag1-inkr tag2-inkr; do tar --extract --gzip --listed-incremental=/dev/null --file="sicherung/$f.tar.gz" -C ziel-inkr; done
echo "== Wiederherstellung Tag 2 über Voll + Differenziell"
mkdir -p ziel-diff
for f in tag0-voll tag2-diff; do tar --extract --gzip --listed-incremental=/dev/null --file="sicherung/$f.tar.gz" -C ziel-diff; done
echo
echo "== Vergleich mit dem Original (Prüfsummen)"
(cd daten && find . -type f -print0 | sort -z | xargs -0 sha256sum) > original.sha
(cd ziel-inkr/daten && find . -type f -print0 | sort -z | xargs -0 sha256sum) > inkr.sha
(cd ziel-diff/daten && find . -type f -print0 | sort -z | xargs -0 sha256sum) > diff.sha
cmp original.sha inkr.sha && echo "Kette Voll+Inkr+Inkr: identisch mit Original"
cmp original.sha diff.sha && echo "Kette Voll+Diff: identisch mit Original"
echo "Dateien im Original: $(find daten -type f | wc -l), in ziel-inkr: $(find ziel-inkr/daten -type f | wc -l), in ziel-diff: $(find ziel-diff/daten -type f | wc -l)"
