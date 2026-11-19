#!/bin/bash
# Spielt drei Sicherungstage mit backup_linux.sh durch und zeigt, dass unveränderte Dateien Hardlinks sind.
# Aufruf:  bash demo_snapshots.sh [Arbeitsordner]     (Standard ./lab05, wird neu angelegt)
set -eu
W="${1:-./lab05}"; HIER="$(cd "$(dirname "$0")" && pwd)"
rm -rf "$W"; mkdir -p "$W/daten/projekte" "$W/daten/privat"
cd "$W"
for i in $(seq 1 50); do head -c 20480 /dev/urandom > "daten/projekte/plan$i.dat"; done
echo "Beispieltext" > daten/privat/notiz.txt
echo "== Tag 1 (Erstsicherung)"
bash "$HIER/backup_linux.sh" daten sicherung 2026-11-01_0200
sleep 2   # rsync vergleicht standardmäßig Größe und Änderungszeit (sekundengenau); ohne Pause sähen geänderte Dateien unverändert aus
echo "== Tag 2: 5 Dateien geändert, 1 neue"
for i in 1 2 3 4 5; do head -c 20480 /dev/urandom > "daten/projekte/plan$i.dat"; done
head -c 20480 /dev/urandom > daten/projekte/plan51.dat
bash "$HIER/backup_linux.sh" daten sicherung 2026-11-02_0200
sleep 2
echo "== Tag 3: 1 Datei gelöscht"
rm daten/projekte/plan10.dat
bash "$HIER/backup_linux.sh" daten sicherung 2026-11-03_0200
echo
echo "== Vorhandene Sicherungen und ihr scheinbarer Umfang (du -sh, einzeln gemessen)"
for d in sicherung/2026-*; do printf '%s  ' "$d"; du -sh "$d" | cut -f1; done
echo "== Gesamtbedarf auf dem Datenträger (du -sh über alle Sicherungen zusammen)"
du -sh sicherung | cut -f1
echo
echo "== Hardlink-Zähler (stat -c '%h') einer unveränderten und einer geänderten Datei"
printf 'plan20.dat (unverändert): '; stat -c '%h Links, Inode %i' sicherung/2026-11-03_0200/projekte/plan20.dat
printf 'plan1.dat  (Tag 2 geändert): '; stat -c '%h Links, Inode %i' sicherung/2026-11-03_0200/projekte/plan1.dat
echo
echo "== Stand von plan10.dat (Tag 3 gelöscht) in den Sicherungen"
for d in sicherung/2026-*; do printf '%s: ' "$d"; [ -e "$d/projekte/plan10.dat" ] && echo vorhanden || echo fehlt; done
echo
echo "== Verweis latest und Protokoll"
ls -l sicherung/latest | awk '{print $9, $10, $11}'
grep -E 'START|OK|FEHLER' sicherung/backup.log
echo
echo "== Trockenlauf: was würde sich seit der letzten Sicherung ändern?"
echo "Neue Datei" > daten/privat/neu.txt
rsync -aH --numeric-ids --delete --dry-run --itemize-changes daten/ sicherung/latest/
