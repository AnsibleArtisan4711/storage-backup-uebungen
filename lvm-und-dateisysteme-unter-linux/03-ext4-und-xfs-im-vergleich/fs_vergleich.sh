#!/usr/bin/env bash
# ext4 und XFS auf je einem Loop-Gerät anlegen und Eigenschaften vergleichen (erfundene Daten).
cd "$(dirname "$0")" || exit 1
. ../lab.sh
lab_up; img_loop e 320M; E=$DEV; img_loop x 320M; X=$DEV
step "1. Dateisysteme anlegen"
mkfs.ext4 -q -L daten_ext4 $E && echo "ext4 angelegt"
mkfs.xfs -q -L daten_xfs $X && echo "xfs angelegt"
mkdir -p $W/e $W/x; mount $E $W/e; mount $X $W/x
step "2. Typ, Bezeichnung und Größe (blkid, df)"
blkid -o export $E | grep -E '^(TYPE|LABEL)='; blkid -o export $X | grep -E '^(TYPE|LABEL)='
df -h --output=fstype,size,used,avail $W/e $W/x
step "3. Inodes: ext4 legt sie beim Anlegen fest, XFS vergibt sie dynamisch"
echo "Dateisystem  Inodes  belegt  frei"; df -i $W/e $W/x | awk 'NR>1{print $1, $2, $3, $4}' | sed -E "s#/dev/loop[0-9]+#loop#"
step "4. Eigenschaften (tune2fs und xfs_info, Auszug)"
tune2fs -l $E | grep -E 'Block size|Inode count|Journal|Filesystem features' | cut -c1-110
xfs_info $W/x | grep -E 'isize|bsize|agcount' | head -3
step "5. Eine Datei und ein Verzeichnis anlegen und Rechte ansehen"
for m in e x; do echo hallo > $W/$m/test.txt; mkdir $W/$m/ordner; done
ls -l $W/e/test.txt $W/x/test.txt | awk '{print $1, $5, $NF}' | sed "s#$W#...#"
step "6. Vergrößern geht bei beiden, Verkleinern nur bei ext4 (siehe Modul 4)"
umount $W/e $W/x; lab_down
