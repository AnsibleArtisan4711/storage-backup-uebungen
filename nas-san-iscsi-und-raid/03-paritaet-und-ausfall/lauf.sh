#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1
python3 xor_raid.py
echo; echo "## Echtes mdadm-RAID im Container: nicht möglich (kein md-Kernelmodul)"
. ../lab.sh
lab_up
for i in 1 2 3; do img_loop r$i 32M; L="$L $DEV"; done
cmd mdadm --version
cmd mdadm --create /dev/md0 --level=5 --raid-devices=3 $L --run
echo "Rückgabecode: $?"
for l in $L; do losetup -d $l; done
lab_down
