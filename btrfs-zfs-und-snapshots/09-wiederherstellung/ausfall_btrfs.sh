#!/usr/bin/env bash
# Ausfall einer Platte im Spiegel: degradiert einbinden, Platte ersetzen, Daten prüfen (Loop-Geräte, erfundene Daten).
cd "$(dirname "$0")" || exit 1
. ../lab.sh
lab_up; img_loop a 300M; A=$DEV; img_loop b 300M; B=$DEV; img_loop z 300M; Z=$DEV
mkfs.btrfs -q -f -d raid1 -m raid1 $A $B; mount $A $W/mnt
for i in 1 2 3; do dd if=/dev/urandom of=$W/mnt/f$i.bin bs=1M count=10 status=none; done; sync
(cd $W/mnt && md5sum f*.bin > $W/md5.txt)
step "1. Ausgangslage: gesunder Spiegel"
btrfs filesystem show $W/mnt | grep -E 'devid' | sed -E 's/ used [^ ]+//'
step "2. Platte B fällt aus (Simulation: Dateisystem aushängen, Loop-Gerät trennen)"
umount $W/mnt; losetup -d $B
echo "-- Normales Einbinden schlägt fehl, weil eine Platte fehlt:"
mount $A $W/mnt 2>&1 | head -1 | sed 's/^mount: //'
echo "-- Meldung des Kernels (dmesg, letzte passende Zeile):"
dmesg 2>/dev/null | grep -E 'devid [0-9]+ uuid .* is missing|failed to read the system array|open_ctree failed' | tail -1 | sed -E 's/^\[[ 0-9.]+\] //; s/uuid [0-9a-f-]+/uuid <UUID>/; s/loop[0-9]+/loopN/'
step "3. Degradiert einbinden (-o degraded): Daten bleiben lesbar"
cmd mount -o degraded $A $W/mnt
(cd $W/mnt && md5sum -c $W/md5.txt)
btrfs filesystem show $W/mnt | grep -E 'devid|MISSING' | sed -E 's/ used [^ ]+//'
step "4. Neue Platte einsetzen: fehlendes Gerät (devid 2) ersetzen"
cmd btrfs replace start -B 2 $Z $W/mnt
btrfs filesystem show $W/mnt | grep -E 'devid|MISSING' | sed -E 's/ used [^ ]+//'
step "5. Prüfen: Scrub und Daten"
btrfs scrub start -B $W/mnt 2>&1 | grep -E 'Error summary'
(cd $W/mnt && md5sum -c $W/md5.txt)
echo "-- Profile nach der Reparatur (beim degradierten Betrieb sind neue Chunks im Profil single entstanden):"
btrfs filesystem df $W/mnt | grep -v GlobalReserve
step "6. Profile wieder vereinheitlichen: Balance nur für Chunks, die noch nicht raid1 sind (soft)"
btrfs balance start -dconvert=raid1,soft -mconvert=raid1,soft $W/mnt 2>&1 | tail -1
btrfs filesystem df $W/mnt | grep -v GlobalReserve
btrfs filesystem usage $W/mnt | grep -E 'Data ratio|Metadata ratio|Multiple profiles' | sed 's/\t\+/ /g'
cd /; lab_down
