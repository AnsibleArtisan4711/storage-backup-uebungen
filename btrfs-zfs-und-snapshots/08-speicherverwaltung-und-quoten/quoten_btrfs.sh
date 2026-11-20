#!/usr/bin/env bash
# Btrfs-Quoten (qgroups): Grenzen je Subvolume setzen und die Wirkung prüfen (Loop-Gerät, erfundene Daten).
cd "$(dirname "$0")" || exit 1
. ../lab.sh
lab_up; img_loop a 300M; mkfs.btrfs -q -f $DEV; mount $DEV $W/mnt; cd $W/mnt
btrfs subvolume create projekt_a >/dev/null; btrfs subvolume create projekt_b >/dev/null
step "1. Quoten einschalten (zuvor meldet btrfs: quotas not enabled)"
btrfs qgroup show . 2>&1 | head -1
cmd btrfs quota enable .
step "2. Grenze setzen: projekt_a höchstens 10 MiB, projekt_b höchstens 40 MiB"
btrfs qgroup limit 10M projekt_a; btrfs qgroup limit 40M projekt_b
step "3. In projekt_a 15 MiB schreiben: bei 10 MiB ist Schluss"
dd if=/dev/urandom of=projekt_a/daten.bin bs=1M count=15 status=none 2>&1 | sed 's/^dd: //'
sync; ls -l projekt_a | awk 'NR>1{print "  "$5" Bytes  "$9}'
step "4. Die Belegung je Subvolume (qgroup show)"
btrfs filesystem sync . ; btrfs qgroup show -re . | sed 's/  */ /g'
step "5. Quote aufheben (none) und erneut schreiben"
btrfs qgroup limit none projekt_a
dd if=/dev/urandom of=projekt_a/mehr.bin bs=1M count=15 status=none && echo "Schreiben ohne Grenze erfolgreich"
btrfs filesystem sync . ; btrfs qgroup show -re . | sed 's/  */ /g'
cd /; lab_down
