#!/usr/bin/env bash
# Block gegen Datei: ein Block-Gerät (wie ein SAN-Laufwerk) hat zunächst nur Bytes; erst das Dateisystem macht daraus Dateien (wie bei einem NAS)
. "$(dirname "$0")/../lab.sh"
lab_up
step "1. Ein 64-MB-Image als Block-Gerät einbinden (Loop-Gerät)"
img_loop platte 64M
echo "Gerät: $DEV"
cmd blockdev --getsize64 $DEV
cmd blkid $DEV
echo "(blkid ohne Ausgabe: kein Dateisystem, nur rohe Blöcke)"
step "2. Rohe Blöcke lesen und schreiben (ohne Dateisystem)"
printf 'Rohdaten im Block 0' | dd of=$DEV bs=512 count=1 conv=notrunc status=none
dd if=$DEV bs=512 count=1 status=none | tr -d '\0'; echo
step "3. Dateisystem anlegen und einbinden: jetzt gibt es Dateien"
cmd mkfs.ext4 -q -L daten $DEV
cmd blkid -o export $DEV
cmd mount $DEV $W/mnt
echo "Hallo vom Dateisystem" > $W/mnt/hallo.txt
cmd ls $W/mnt
cmd df -T $W/mnt
step "4. Aufteilung der Zuständigkeit"
echo "Block-Zugriff (SAN, iSCSI): der Client legt das Dateisystem an und verwaltet es."
echo "Datei-Zugriff (NAS, NFS/SMB): der Server verwaltet das Dateisystem, der Client sieht Dateien."
umount $W/mnt; losetup -d $DEV
lab_down
