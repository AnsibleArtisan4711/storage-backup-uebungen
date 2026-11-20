#!/usr/bin/env bash
# ext4 beschädigen (nur in der Image-Datei!) und mit e2fsck reparieren (Loop-Gerät, erfundene Daten).
cd "$(dirname "$0")" || exit 1
. ../lab.sh
lab_up; img_loop e 100M; E=$DEV; mkfs.ext4 -q $E; mkdir -p $W/m; mount $E $W/m
for i in 1 2 3 4 5; do echo "Datei $i" > $W/m/datei$i.txt; done; mkdir $W/m/ordner; sync; umount $W/m
step "1. Zustand prüfen (nur lesen, -n)"
cmd e2fsck -fn $E | tail -2
step "2. Beschädigen: Linkzähler einer Datei mit debugfs verfälschen (nur in der Image-Datei)"
debugfs -w -R "set_inode_field /datei3.txt links_count 5" $E 2>&1 | tail -1
step "3. Erneut prüfen: Fehler werden gemeldet (Exitcode 4 = Fehler nicht korrigiert)"
e2fsck -fn $E 2>&1 | grep -vE "^e2fsck [0-9]" | head -8; echo "Exitcode: ${PIPESTATUS[0]}"
step "4. Reparieren (-y beantwortet alle Fragen mit ja)"
e2fsck -fy $E 2>&1 | grep -vE "^e2fsck [0-9]" | head -8; echo "Exitcode: ${PIPESTATUS[0]}"
step "5. Danach sauber, Dateien noch vorhanden"
e2fsck -fn $E | tail -1; mount $E $W/m; ls $W/m | grep -v lost; umount $W/m
lab_down
