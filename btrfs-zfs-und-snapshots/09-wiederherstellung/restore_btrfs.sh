#!/usr/bin/env bash
# Einzelne Dateien aus einem Snapshot zurückholen (Loop-Gerät, erfundene Daten).
cd "$(dirname "$0")" || exit 1
. ../lab.sh
lab_up; img_loop a 300M; mkfs.btrfs -q -f $DEV; mount $DEV $W/mnt; cd $W/mnt
btrfs subvolume create daten >/dev/null; mkdir .snap daten/berichte
echo "Bericht Q1 (Version 1)" > daten/berichte/q1.txt; echo "Bericht Q2" > daten/berichte/q2.txt; echo "Vertrag" > daten/vertrag.txt
dd if=/dev/urandom of=daten/anlage.bin bs=1M count=5 status=none; sync
md5sum daten/anlage.bin | cut -c1-8 > $W/anlage.md5
step "1. Snapshot als Sicherungspunkt, danach: drei Dateien gelöscht, eine Datei verändert"
btrfs subvolume snapshot -r daten .snap/vor-unfall >/dev/null
rm daten/vertrag.txt; echo "kaputt" > daten/berichte/q1.txt; rm daten/berichte/q2.txt; rm daten/anlage.bin
find daten -type f | sort; echo "q1.txt: $(cat daten/berichte/q1.txt)"
step "2. Gelöschte Datei zurückholen (kopieren aus dem Snapshot)"
cmd cp -a .snap/vor-unfall/vertrag.txt daten/
cat daten/vertrag.txt
step "3. Veränderte Datei zurückholen und große Datei ohne Platzverbrauch (Reflink) zurückholen"
cp -a .snap/vor-unfall/berichte/q1.txt daten/berichte/q1.txt; cat daten/berichte/q1.txt
cmd cp -a --reflink=always .snap/vor-unfall/anlage.bin daten/
echo "anlage.bin: Prüfsumme gleich wie vorher: $([ "$(md5sum daten/anlage.bin | cut -c1-8)" = "$(cat $W/anlage.md5)" ] && echo ja || echo NEIN)"
btrfs filesystem du -s daten .snap/vor-unfall | sed 's/  */ /g'
step "4. Ganzes Verzeichnis zurückholen"
cp -a .snap/vor-unfall/berichte/. daten/berichte/
find daten -type f | sort
step "5. Alte Stände ansehen: mehrere Snapshots, Datei vergleichen (diff)"
echo "Bericht Q1 (Version 2)" > daten/berichte/q1.txt; btrfs subvolume snapshot -r daten .snap/nach-aenderung >/dev/null
diff <(cat .snap/vor-unfall/berichte/q1.txt) <(cat .snap/nach-aenderung/berichte/q1.txt) | sed 's/^/  /'
cd /; lab_down
