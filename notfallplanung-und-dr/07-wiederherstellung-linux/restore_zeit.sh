#!/bin/bash
# Wiederherstellung messen: Wie lange dauert der Restore wirklich, und passt das zum RTO?
# Aufruf: bash restore_zeit.sh [Arbeitsordner] [RTO_Sekunden]
# Ein "Server" besteht hier aus 200 Dateien (rund 40 MB). Gemessen wird nur diese Laborgröße; Hochrechnung auf echte Datenmengen ist Aufgabe der Übung.
set -eu
W="${1:-./lab_dr07}"; RTO="${2:-5}"; rm -rf "$W"; mkdir -p "$W/server/etc" "$W/server/daten" && cd "$W"
echo "LabKennwort-nur-fuer-Uebung" > kennwort.txt
export RESTIC_REPOSITORY="$PWD/repo" RESTIC_PASSWORD_FILE="$PWD/kennwort.txt"
echo "dienst=demo" > server/etc/demo.conf
for i in $(seq 1 200); do head -c 204800 /dev/urandom > server/daten/f$i.bin; done
du -sm server | awk '{print "Datenmenge: " $1 " MB"}'
restic init -q; restic backup -q server
echo "== Katastrophe: Server-Ordner weg"
rm -rf server
t0=$(date +%s.%N)
restic restore latest --target . -q
t1=$(date +%s.%N)
ZD=$(find . -maxdepth 4 -type d -name server | head -n 1)
n=$(find "$ZD" -type f | wc -l)
dauer=$(echo "$t1 - $t0" | bc -l)
printf "Wiederhergestellt: %d Dateien in %.2f s\n" "$n" "$dauer"
MB=$(du -sm "$ZD" | cut -f1); rate=$(echo "$MB / $dauer" | bc -l)
printf "Durchsatz: %.0f MB/s\n" "$rate"
echo "== Hochrechnung auf 500 GB (nur Schätzung, lineare Annahme)"
printf "500 GB bei %.0f MB/s: %.1f Minuten\n" "$rate" "$(echo "500*1024/$rate/60" | bc -l)"
if (( $(echo "$dauer <= $RTO" | bc -l) )); then echo "Laborziel $RTO s: erreicht"; else echo "Laborziel $RTO s: verfehlt"; fi
