#!/usr/bin/env bash
# Btrfs im laufenden Betrieb verändern: Platte hinzufügen, Balance, Profil wechseln, Platte entfernen (Loop-Geräte, erfundene Daten).
cd "$(dirname "$0")" || exit 1
. ../lab.sh
lab_up; img_loop a 300M; A=$DEV; img_loop b 300M; B=$DEV; img_loop c 300M; C=$DEV
mkfs.btrfs -q -f $A; mount $A $W/mnt
dd if=/dev/urandom of=$W/mnt/daten.bin bs=1M count=100 status=none; sync
step "1. Ausgangslage: eine Platte, Profil single (Daten), DUP (Metadaten)"
btrfs filesystem show $W/mnt | grep -E 'devid|Total' | sed -E 's/uuid: [0-9a-f-]+/uuid: <UUID>/'
btrfs filesystem df $W/mnt | head -3
step "2. Zweite Platte hinzufügen und auf raid1 umstellen (Balance mit Konvertierung)"
cmd btrfs device add -f $B $W/mnt
cmd btrfs balance start -dconvert=raid1 -mconvert=raid1 $W/mnt
btrfs filesystem df $W/mnt | head -3
step "3. Dritte Platte hinzufügen und Daten gleichmäßig verteilen"
btrfs device add -f $C $W/mnt >/dev/null
btrfs balance start -dusage=100 $W/mnt 2>&1 | tail -1
btrfs filesystem show $W/mnt | grep -E 'devid' | sed 's/path.*//'
step "4. Platte wieder entfernen (Daten werden zuvor auf die anderen verschoben)"
cmd btrfs device remove $C $W/mnt
btrfs filesystem show $W/mnt | grep -E 'devid|Total' | sed -E 's/path.*//'
step "5. Die Prüfsummen bleiben gültig: Scrub nach den Änderungen"
btrfs scrub start -B $W/mnt 2>&1 | grep -E 'Error summary'
cd /; lab_down
