#!/usr/bin/env bash
# Typischer Fehler: „No space left on device“, obwohl Dateien gelöscht wurden (Snapshot hält die Blöcke) (Loop-Gerät, erfundene Daten).
cd "$(dirname "$0")" || exit 1
. ../lab.sh
lab_up; img_loop a 300M; mkfs.btrfs -q -f $DEV; mount $DEV $W/mnt; cd $W/mnt
btrfs subvolume create daten >/dev/null; mkdir .snap
frei() { echo "  df: $(df -h --output=used,avail . | tail -1 | sed 's/  */ /g') (belegt, verfügbar); Data logisch belegt: $(btrfs filesystem usage -b . | awk '/Data,single/{sub("Used:","",$3); print int($3/1048576)}' | tr -d ',') MiB"; }
step "1. 120 MiB schreiben"
dd if=/dev/urandom of=daten/a.bin bs=1M count=120 status=none; sync; frei
step "2. Snapshot anlegen, Datei löschen: der Platz wird nicht frei"
btrfs subvolume snapshot -r daten .snap/s1 >/dev/null
rm daten/a.bin; sync; frei
echo "  Datei in daten: $(ls daten | wc -l) Dateien; im Snapshot: $(ls .snap/s1 | wc -l) Datei"
step "3. Weitere Daten schreiben bis der Platz ausgeht"
for i in 1 2 3; do dd if=/dev/urandom of=daten/b$i.bin bs=1M count=70 status=none 2>&1 | sed 's/^dd: //'; sync; done; frei
step "4. Ursache finden und beseitigen: Snapshots auflisten, den Snapshot löschen, dann erneut schreiben"
btrfs subvolume list -s . | awk '{print "  Snapshot ID " $2 ", Pfad " $NF}'
btrfs subvolume delete -c .snap/s1 >/dev/null; sync; sleep 1; frei
dd if=/dev/urandom of=daten/b4.bin bs=1M count=70 status=none && echo "  Schreiben gelingt jetzt"; sync; frei
cd /; lab_down
