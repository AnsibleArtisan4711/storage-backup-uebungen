#!/usr/bin/env bash
# Btrfs: ein Dateisystem über mehrere Platten (raid1), Subvolumes anlegen und gezielt einbinden (Loop-Geräte, erfundene Daten).
cd "$(dirname "$0")" || exit 1
. ../lab.sh
lab_up; img_loop d1 300M; D1=$DEV; img_loop d2 300M; D2=$DEV
step "1. Dateisystem über zwei Platten: Daten und Metadaten gespiegelt (raid1)"
cmd mkfs.btrfs -q -f -L lernpool -d raid1 -m raid1 $D1 $D2
mount $D1 $W/mnt
cmd btrfs filesystem show $W/mnt | sed -E 's/uuid: [0-9a-f-]+/uuid: <UUID>/'
step "2. Subvolumes anlegen (sehen aus wie Verzeichnisse, haben aber eigene Eigenschaften)"
cmd btrfs subvolume create $W/mnt/daten
cmd btrfs subvolume create $W/mnt/home
cmd btrfs subvolume list $W/mnt
step "3. Dateien in die Subvolumes schreiben"
echo "Beispieltext" > $W/mnt/daten/notiz.txt; mkdir $W/mnt/verz; echo "gewöhnliches Verzeichnis" > $W/mnt/verz/x.txt
ls -l $W/mnt | awk 'NR>1{print "  "$1, $NF}'
step "4. Ein Subvolume getrennt einbinden (wie eine eigene Partition) mit -o subvol"
mkdir -p $W/mnt2; mount -o subvol=daten $D1 $W/mnt2
ls $W/mnt2
umount $W/mnt2; rmdir $W/mnt2
step "5. Belegung und Profile (Auszug aus btrfs filesystem usage und df)"
btrfs filesystem usage $W/mnt | grep -E 'Data ratio|Metadata ratio|Device size|Device allocated|Device unallocated' | sed 's/\t\+/ /g'
btrfs filesystem df $W/mnt
cd /; lab_down
