#!/usr/bin/env bash
# ext4 und XFS auf Loop-Geräten: anlegen, einbinden, vergleichen, vergrößern, prüfen
. "$(dirname "$0")/../lab.sh"
lab_up
step "1. ext4 anlegen und Eckdaten lesen"
img_loop e 64M; E=$DEV
cmd mkfs.ext4 -q -L daten-ext4 $E
tune2fs -l $E | grep -E 'Filesystem volume name|Block size|Inode count|Filesystem features' | sed -E 's/ +/ /g'
step "2. XFS anlegen und Eckdaten lesen"
img_loop x 300M; X=$DEV
cmd mkfs.xfs -q -L datenxfs $X
mkdir -p $W/mnt-x
mount $X $W/mnt-x
xfs_info $W/mnt-x | grep -E 'isize|bsize|data  ' | sed -E 's/ +/ /g'
step "3. Beide einbinden und vergleichen"
mount $E $W/mnt
cmd df -T $W/mnt $W/mnt-x
step "4. Vergrößern: Image erweitern, Loop-Gerät aktualisieren"
umount $W/mnt
truncate -s 128M $W/e.img; losetup -c $E
cmd e2fsck -fn $E
resize2fs $E 2>&1 | grep "is now"
mount $E $W/mnt; df -h $W/mnt | tail -1
truncate -s 400M $W/x.img; losetup -c $X
cmd xfs_growfs $W/mnt-x
df -h $W/mnt-x | tail -1
step "5. Prüfen (nur lesend): ext4 mit e2fsck -n, XFS mit xfs_repair -n"
umount $W/mnt $W/mnt-x
cmd e2fsck -fn $E
echo "$ xfs_repair -n $X (nur Anfang und Ende der Ausgabe)"; xfs_repair -n $X 2>&1 | sed -n "1,2p;\$p"
losetup -d $E $X
lab_down
