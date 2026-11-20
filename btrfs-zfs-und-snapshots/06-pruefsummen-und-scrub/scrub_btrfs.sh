#!/usr/bin/env bash
# Btrfs-Scrub: Beschädigung einer Platte erkennen und aus dem Spiegel reparieren (raid1); ohne Spiegel (single) nur erkennen (Loop-Geräte, erfundene Daten).
cd "$(dirname "$0")" || exit 1
. ../lab.sh
lab_up
korrumpiere() { dd if=/dev/urandom of=$1 bs=1M seek=$2 count=$3 conv=notrunc status=none; sync; echo 3 > /proc/sys/vm/drop_caches; }
step "1. Spiegel (raid1): Dateien anlegen, Prüfsummen merken"
img_loop a 300M; A=$DEV; img_loop b 300M; B=$DEV
mkfs.btrfs -q -f -d raid1 -m raid1 $A $B; mount $A $W/mnt
for i in 1 2 3; do dd if=/dev/urandom of=$W/mnt/f$i.bin bs=1M count=10 status=none; done; sync
(cd $W/mnt && md5sum f*.bin > $W/md5.txt); cat $W/md5.txt | sed 's/^\(.\{8\}\).\{24\}/\1.../'
step "2. Platte B beschädigen: 100 MiB Zufallsdaten mitten in das Image schreiben (Simulation eines Datenträgerfehlers)"
korrumpiere $B 40 100
step "3. Scrub: erkennt Prüfsummenfehler und repariert sie aus der Kopie auf Platte A"
btrfs scrub start -B $W/mnt 2>&1 | grep -E 'WARNING|Status|Error summary|Corrected|Uncorrectable|Unverified'
echo "-- Fehlerzähler je Gerät:"; btrfs device stats $W/mnt | grep -E 'corruption_errs|read_io_errs' | sed 's/^\[[^]]*\]/[Gerät]/' | sort | uniq -c
echo "-- Daten nach der Reparatur lesbar und unverändert:"; (cd $W/mnt && md5sum -c $W/md5.txt)
echo "-- Zweiter Scrub: jetzt fehlerfrei"; btrfs scrub start -B $W/mnt 2>&1 | grep -E 'Error summary'
btrfs device stats -z $W/mnt >/dev/null
umount $W/mnt; losetup -d $A; losetup -d $B
step "4. Ohne Spiegel (single): Beschädigung wird erkannt, aber nicht repariert"
img_loop s 300M; S=$DEV; mkfs.btrfs -q -f -d single -m single $S; mount $S $W/mnt
yes 'BTRFS-Lernmuster-Zeile' | head -c 30M > $W/mnt/g.bin; sync
OFF=$(python3 -c "
import mmap
f = open('$W/s.img', 'rb'); m = mmap.mmap(f.fileno(), 0, access=mmap.ACCESS_READ)
print(m.find(b'BTRFS-Lernmuster-Zeile'))")
echo "Die Dateidaten beginnen im Image bei Byte $OFF (gefunden durch Suche nach dem Muster)."
dd if=/dev/urandom of=$S bs=4096 seek=$((OFF / 4096 + 16)) count=256 conv=notrunc status=none; sync; echo 3 > /proc/sys/vm/drop_caches
btrfs scrub start -B $W/mnt 2>&1 | grep -E 'WARNING|Error summary|Corrected|Uncorrectable'
echo "-- Lesen der beschädigten Datei: Fehlermeldung statt falscher Daten"
dd if=$W/mnt/g.bin of=/dev/null bs=1M 2>&1 | grep -E 'Input/output' | head -1
echo "-- Kernelmeldungen zu Prüfsummenfehlern (dmesg, Auszug):"
dmesg 2>/dev/null | grep -E 'csum failed' | tail -1 | sed -E 's/^\[[ 0-9.]+\] //; s/loop[0-9]+/loopN/g; s/ino [0-9]+/ino N/; s/off [0-9]+/off N/; s/csum 0x[0-9a-f]+ expected csum 0x[0-9a-f]+/csum ... expected csum .../'
cd /; lab_down
