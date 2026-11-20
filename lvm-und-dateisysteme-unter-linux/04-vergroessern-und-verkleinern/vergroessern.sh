#!/usr/bin/env bash
# Dateisysteme vergrößern und verkleinern (Loop-Geräte, erfundene Daten). Bei LVM wäre vorher lvextend nötig (Modul 2, nicht ausführbar).
cd "$(dirname "$0")" || exit 1
. ../lab.sh
lab_up; img_loop e 100M; E=$DEV; img_loop x 320M; X=$DEV
mkfs.ext4 -q $E; mkfs.xfs -q $X; mkdir -p $W/e $W/x; mount $E $W/e; mount $X $W/x
dd if=/dev/urandom of=$W/e/daten bs=1M count=20 status=none; dd if=/dev/urandom of=$W/x/daten bs=1M count=20 status=none; sync
step "1. Ausgangslage"
df -h --output=fstype,size,used $W/e $W/x
step "2. Images vergrößern (ext4 auf 300 MiB, XFS auf 420 MiB), dann ext4 anpassen"
truncate -s 300M $W/e.img; truncate -s 420M $W/x.img; losetup -c $E; losetup -c $X
echo "(Online-Vergrößerung von ext4 wurde im Container verweigert; hier daher ausgehängt, mit vorheriger Prüfung. Auf einem normalen System geht es eingehängt.)"
umount $W/e; cmd e2fsck -f -p $E | tail -1; cmd resize2fs $E | tail -1; mount $E $W/e
step "3. XFS anpassen (xfs_growfs arbeitet auf dem eingehängten Dateisystem)"
cmd xfs_growfs $W/x >/dev/null; echo "(xfs_growfs ausgeführt)"
df -h --output=fstype,size,used $W/e $W/x
step "4. ext4 verkleinern: aushängen, prüfen, verkleinern"
umount $W/e; cmd e2fsck -f -p $E | tail -1
cmd resize2fs $E 80M | tail -1
mount $E $W/e; df -h --output=fstype,size,used $W/e; echo "Daten noch da: $(ls -l $W/e/daten | awk '{print $5}') Bytes"
step "5. XFS verkleinern: nicht unterstützt"
xfs_growfs -D 20000 $W/x 2>&1 | head -2
umount $W/e $W/x; lab_down
