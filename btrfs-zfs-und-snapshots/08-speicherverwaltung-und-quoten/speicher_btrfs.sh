#!/usr/bin/env bash
# Btrfs: Platzbelegung richtig lesen (df, filesystem df, usage, du) und was Snapshots und Spiegel daran ändern (Loop-Geräte, erfundene Daten).
cd "$(dirname "$0")" || exit 1
. ../lab.sh
lab_up; img_loop a 400M; A=$DEV; img_loop b 400M; B=$DEV
mkfs.btrfs -q -f -d raid1 -m raid1 $A $B; mount $A $W/mnt; cd $W/mnt
btrfs subvolume create daten >/dev/null
dd if=/dev/urandom of=daten/gross.bin bs=1M count=50 status=none; sync
step "1. df zeigt die Größe des Spiegels, nicht die Summe beider Platten"
df -h --output=size,used,avail . | sed 's/  */ /g'
echo "(zwei Platten à 400 MiB, gespiegelt: nutzbar etwa 400 MiB; 50 MiB Daten belegen 100 MiB auf den Platten)"
step "2. btrfs filesystem df: Belegung nach Datenart und Profil"
btrfs filesystem df .
step "3. btrfs filesystem usage: Belegung je Gerät und Spiegelfaktor"
btrfs filesystem usage -T . | sed 's/\t\+/ /g'
step "4. Snapshot anlegen und Daten löschen: der Platz wird nicht frei, solange der Snapshot sie hält"
mkdir .snap; btrfs subvolume snapshot -r daten .snap/s1 >/dev/null
rm daten/gross.bin; sync
echo "daten (aktuell):  $(du -sh daten | cut -f1)"
echo "Snapshot s1:      $(du -sh .snap/s1 | cut -f1)"
echo "Data belegt:       $(btrfs filesystem usage -b . | awk '/Data,RAID1/{sub("Used:","",$3); print $3}' | tr -d ',') Bytes logisch belegt (unverändert 50 MiB = 52428800; auf den Platten wegen des Spiegels doppelt)"
btrfs subvolume delete -c .snap/s1 >/dev/null; sync; sleep 1
echo "nach dem Löschen des Snapshots: $(btrfs filesystem usage -b . | awk '/Data,RAID1/{sub("Used:","",$3); print $3}' | tr -d ',') Bytes"
cd /; lab_down
