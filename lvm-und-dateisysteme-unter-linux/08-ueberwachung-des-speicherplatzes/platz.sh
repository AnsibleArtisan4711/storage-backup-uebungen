#!/usr/bin/env bash
# Speicherplatz überwachen: df, Inodes, "No space left" trotz freiem Platz (Loop-Gerät, erfundene Daten).
cd "$(dirname "$0")" || exit 1
. ../lab.sh
lab_up; img_loop e 20M; E=$DEV; mkfs.ext4 -q -N 200 $E; mkdir -p $W/m; mount $E $W/m
step "1. Belegung (df) und Inodes (df -i) bei einem Dateisystem mit nur 200 Inodes"
df -h $W/m | awk 'NR>1{print "Platz:  Größe "$2", belegt "$3", frei "$4", "$5}'
df -i $W/m | awk 'NR>1{print "Inodes: gesamt "$2", belegt "$3", frei "$4", "$5}'
step "2. Viele kleine Dateien anlegen, bis es nicht mehr geht"
n=0; while touch $W/m/f$n 2>/dev/null; do n=$((n+1)); done; echo "Dateien angelegt: $n"
touch $W/m/noch_eine 2>&1 | sed "s#$W#...#"
step "3. Platz ist frei, Inodes sind aufgebraucht"
df -h $W/m | awk 'NR>1{print "Platz:  belegt "$3", frei "$4", "$5}'
df -i $W/m | awk 'NR>1{print "Inodes: frei "$4", "$5}'
step "4. Größte Verzeichnisse und Dateien finden (du, find)"
mkdir $W/m/gross; dd if=/dev/zero of=$W/m/gross/a.bin bs=1k count=100 status=none 2>/dev/null || echo "(Anlegen scheitert: keine Inodes mehr frei)"
rm -f $W/m/f1*; dd if=/dev/zero of=$W/m/a.bin bs=1k count=3000 status=none; dd if=/dev/zero of=$W/m/b.bin bs=1k count=1000 status=none
du -ak $W/m 2>/dev/null | sort -rn | grep -E "\.bin" | sed "s#$W#...#"
find $W/m -size +2M -printf '%s %p\n' | sed "s#$W#...#"
umount $W/m; lab_down
