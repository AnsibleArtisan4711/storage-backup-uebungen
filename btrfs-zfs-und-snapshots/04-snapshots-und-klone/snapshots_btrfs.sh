#!/usr/bin/env bash
# Btrfs-Snapshots: schreibgeschützt und beschreibbar, Platzbedarf, Zugriff auf alte Stände (Loop-Gerät, erfundene Daten).
cd "$(dirname "$0")" || exit 1
. ../lab.sh
lab_up; img_loop a 300M; mkfs.btrfs -q -f $DEV; mount $DEV $W/mnt; cd $W/mnt
btrfs subvolume create daten >/dev/null; mkdir .snap
dd if=/dev/urandom of=daten/gross.bin bs=1M count=20 status=none; echo "Version 1" > daten/notiz.txt; sync
step "1. Schreibgeschützten Snapshot anlegen (-r) und Platzbedarf prüfen"
cmd btrfs subvolume snapshot -r daten .snap/daten-s1
btrfs filesystem du -s daten .snap/daten-s1
echo "belegt insgesamt (Data): $(btrfs filesystem usage -b . | awk '/Data,single/{sub("Used:","",$3); print $3}' | tr -d ',') Bytes (20 MiB = 20971520)"
step "2. Daten ändern: der Snapshot behält den alten Stand"
echo "Version 2" > daten/notiz.txt; dd if=/dev/urandom of=daten/gross.bin bs=1M count=2 conv=notrunc status=none; sync
echo "aktuell:  $(cat daten/notiz.txt)"; echo "Snapshot: $(cat .snap/daten-s1/notiz.txt)"
btrfs filesystem du -s daten .snap/daten-s1
step "3. Der Snapshot ist schreibgeschützt"
bash -c 'echo ändern > .snap/daten-s1/notiz.txt' 2>&1 | sed 's/^.*: //' | sed 's/^/Schreiben: /'
touch .snap/daten-s1/neu 2>&1 | sed 's/^.*: //' | sed 's/^/Anlegen:   /'
step "4. Beschreibbaren Snapshot (Klon) anlegen und darin arbeiten"
cmd btrfs subvolume snapshot daten klon
echo "Klon-Version" > klon/notiz.txt
echo "daten: $(cat daten/notiz.txt)  klon: $(cat klon/notiz.txt)"
step "5. Snapshots auflisten und löschen"
btrfs subvolume list . | sed 's/gen [0-9]* //'
cmd btrfs subvolume delete .snap/daten-s1
sync; sleep 1
btrfs subvolume list . | sed 's/gen [0-9]* //'
cd /; lab_down
