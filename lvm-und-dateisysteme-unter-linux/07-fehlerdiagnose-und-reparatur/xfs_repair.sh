#!/usr/bin/env bash
# XFS: Prüfung im Nur-Lesen-Modus und Reparatur (Loop-Gerät, erfundene Daten).
cd "$(dirname "$0")" || exit 1
. ../lab.sh
lab_up; img_loop x 320M; X=$DEV; mkfs.xfs -q $X; mkdir -p $W/m; mount $X $W/m
for i in 1 2 3; do echo "Datei $i" > $W/m/d$i.txt; done; sync; umount $W/m
step "1. Prüfen ohne zu ändern (xfs_repair -n)"
xfs_repair -n $X 2>&1 | grep -E "Phase|No modify|no problem|bad|corrupt" | head -8
step "2. Primären Superblock überschreiben und erneut prüfen"
dd if=/dev/zero of=$X bs=512 count=1 conv=notrunc status=none
xfs_repair -n $X 2>&1 | grep -E "bad primary|Sorry|found candidate|error" | head -4
step "3. Reparieren: xfs_repair findet den Zweitsuperblock"
xfs_repair $X 2>&1 | grep -E "bad primary|Phase 1|done" | head -4
step "4. Danach lässt sich das Dateisystem einbinden"
mount $X $W/m && ls $W/m; umount $W/m
lab_down
