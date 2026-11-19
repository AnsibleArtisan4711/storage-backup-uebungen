#!/bin/bash
# Versionierte Sicherung mit rsync und Hardlinks: jede Sicherung ist ein vollständiger Verzeichnisbaum,
# unveränderte Dateien sind Hardlinks auf die vorige Sicherung (--link-dest) und brauchen keinen Platz.
# Aufruf:  bash backup_linux.sh QUELLE ZIEL [STEMPEL]
#   QUELLE   Ordner, der gesichert wird (ohne abschließenden Schrägstrich angeben)
#   ZIEL     Ordner mit den Sicherungen (wird angelegt); darf nicht innerhalb der Quelle liegen
#   STEMPEL  Name der Sicherung, Standard: Datum und Uhrzeit
# Rückgabewert: 0 = Erfolg, sonst Rückgabewert von rsync (24 = Quelldatei während des Laufs verschwunden, wird als Erfolg gewertet)
set -u
[ $# -ge 2 ] || { echo "Aufruf: $0 QUELLE ZIEL [STEMPEL]"; exit 2; }
QUELLE="${1%/}"; ZIEL="${2%/}"; STEMPEL="${3:-$(date +%Y-%m-%d_%H%M%S)}"
[ -d "$QUELLE" ] || { echo "Quelle fehlt: $QUELLE"; exit 2; }
[ -n "$ZIEL" ] || { echo "Ziel leer"; exit 2; }
QA="$(readlink -f "$QUELLE")"; mkdir -p "$ZIEL"; ZA="$(readlink -f "$ZIEL")"
case "$ZA/" in "$QA"/*) echo "Ziel liegt innerhalb der Quelle: abgebrochen"; exit 2 ;; esac
LOG="$ZA/backup.log"
OPT=(-aH --numeric-ids --delete --stats)
if [ -L "$ZA/latest" ]; then OPT+=(--link-dest="$(readlink -f "$ZA/latest")"); fi
echo "$(date '+%F %T') START $STEMPEL von $QA" >> "$LOG"
rsync "${OPT[@]}" "$QA/" "$ZA/$STEMPEL.partial/" >> "$LOG" 2>&1
rc=$?
if [ $rc -eq 0 ] || [ $rc -eq 24 ]; then
  mv "$ZA/$STEMPEL.partial" "$ZA/$STEMPEL" && ln -sfn "$STEMPEL" "$ZA/latest"
  echo "$(date '+%F %T') OK    $STEMPEL (rsync $rc)" >> "$LOG"
  echo "OK: $STEMPEL"
  exit 0
fi
echo "$(date '+%F %T') FEHLER $STEMPEL (rsync $rc)" >> "$LOG"
echo "FEHLER: rsync $rc, siehe $LOG"
exit $rc
