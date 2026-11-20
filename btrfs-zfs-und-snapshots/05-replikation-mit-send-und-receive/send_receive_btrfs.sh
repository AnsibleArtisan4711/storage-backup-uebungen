#!/usr/bin/env bash
# Btrfs send/receive: Snapshots auf ein zweites Dateisystem übertragen, zuerst vollständig, dann inkrementell (Loop-Geräte, erfundene Daten).
cd "$(dirname "$0")" || exit 1
. ../lab.sh
lab_up; img_loop q 300M; Q=$DEV; img_loop z 300M; Z=$DEV
mkfs.btrfs -q -f -L quelle $Q; mkfs.btrfs -q -f -L ziel $Z
mkdir -p $W/q $W/z; mount $Q $W/q; mount $Z $W/z; mkdir $W/q/.snap $W/z/sicherung
btrfs subvolume create $W/q/daten >/dev/null
dd if=/dev/urandom of=$W/q/daten/gross.bin bs=1M count=20 status=none; echo "Version 1" > $W/q/daten/notiz.txt; sync
size() { stat -c %s "$1"; }
step "1. Erster Snapshot und vollständige Übertragung (schreibgeschützter Snapshot ist Pflicht)"
cmd btrfs subvolume snapshot -r $W/q/daten $W/q/.snap/s1
btrfs send -q -f $W/s1.strom $W/q/.snap/s1
echo "Größe des Datenstroms (voll): $(size $W/s1.strom) Bytes (Daten 20 MiB = 20971520, plus Verwaltung)"
cmd btrfs receive -q -f $W/s1.strom $W/z/sicherung
ls $W/z/sicherung
step "2. Änderung: 1 MiB der großen Datei und die Notiz ändern, zweiter Snapshot"
dd if=/dev/urandom of=$W/q/daten/gross.bin bs=1M count=1 conv=notrunc status=none; echo "Version 2" > $W/q/daten/notiz.txt; sync
cmd btrfs subvolume snapshot -r $W/q/daten $W/q/.snap/s2
step "3. Inkrementelle Übertragung mit -p (Elternsnapshot s1): nur die Unterschiede"
btrfs send -q -p $W/q/.snap/s1 -f $W/s2.strom $W/q/.snap/s2
echo "Größe des Datenstroms (inkrementell): $(size $W/s2.strom) Bytes (statt $(size $W/s1.strom))"
cmd btrfs receive -q -f $W/s2.strom $W/z/sicherung
ls $W/z/sicherung
step "4. Vergleich: Ziel stimmt mit der Quelle überein"
for s in s1 s2; do
  a=$(cd $W/q/.snap/$s && find . -type f | sort | xargs md5sum | md5sum | cut -c1-8)
  b=$(cd $W/z/sicherung/$s && find . -type f | sort | xargs md5sum | md5sum | cut -c1-8)
  echo "$s: Prüfsumme Quelle $a, Ziel $b -> $([ "$a" = "$b" ] && echo gleich || echo VERSCHIEDEN)"
done
echo "Notiz im Ziel (s1): $(cat $W/z/sicherung/s1/notiz.txt); (s2): $(cat $W/z/sicherung/s2/notiz.txt)"
step "5. Die Snapshots im Ziel sind schreibgeschützt und teilen Blöcke (Platz)"
btrfs filesystem du -s $W/z/sicherung/s1 $W/z/sicherung/s2
cd /; lab_down
