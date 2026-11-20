#!/usr/bin/env bash
# Copy-on-Write in Btrfs: Reflink-Kopie teilt Blöcke mit dem Original, bis eine Seite geändert wird (Loop-Gerät, erfundene Daten).
cd "$(dirname "$0")" || exit 1
. ../lab.sh
lab_up; img_loop a 200M; mkfs.btrfs -q -f $DEV; mount $DEV $W/mnt; cd $W/mnt
step "1. 8-MB-Datei anlegen und eine Reflink-Kopie erzeugen (kein Kopieren der Daten)"
dd if=/dev/urandom of=original.bin bs=1M count=8 status=none; sync
cmd cp --reflink=always original.bin kopie.bin
cmd btrfs filesystem du original.bin kopie.bin
echo "(Total = was die Datei umfasst; Exclusive = nur diese Datei belegt; Set shared = von beiden gemeinsam genutzt.)"
step "2. Belegter Platz: eine Kopie kostet fast nichts"
btrfs filesystem usage -b . | grep -E 'Data,single' | sed -E 's/Size:([0-9]+), Used:([0-9]+).*/belegt: \2 Bytes/' 
step "3. Dieselben Blöcke auf dem Datenträger (filefrag: physische Adresse)"
for f in original.bin kopie.bin; do echo "$f: $(filefrag -e $f | awk '/^ *0:/{split($4,a,"."); print "erster Extent beginnt bei physischem Block "a[1]}')"; done
step "4. Kopie ändern: nur die geänderten Blöcke werden neu geschrieben (Copy-on-Write)"
dd if=/dev/urandom of=kopie.bin bs=1M count=1 conv=notrunc status=none; sync
cmd btrfs filesystem du original.bin kopie.bin
for f in original.bin kopie.bin; do echo "$f: $(filefrag -e $f | awk '/^ *[0-9]+:/{split($4,a,"."); printf a[1]" "}')"; done
echo "(Die ersten Blöcke der Kopie liegen jetzt an anderer Stelle; der Rest ist weiter gemeinsam.)"
step "5. Inhalt vergleichen"
cmp -n 1048576 original.bin kopie.bin > /dev/null && echo "erstes MB gleich" || echo "erstes MB verschieden (geändert)"
cmp -i 1048576 original.bin kopie.bin && echo "Rest der Dateien gleich"
cd /; lab_down
