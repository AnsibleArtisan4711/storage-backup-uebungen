#!/usr/bin/env bash
# LVM-Metadaten: Physical Volumes und Volume Group auf Loop-Geräten (Logical Volumes sind im Container nicht möglich, kein Device-Mapper).
cd "$(dirname "$0")" || exit 1
. ../lab.sh
lab_up; img_loop a 300M; A=$DEV; img_loop b 300M; B=$DEV
step "1. Physical Volumes anlegen"
cmd pvcreate -q $A $B
step "2. Volume Group anlegen (Extent-Größe 4 MiB ist der Standard)"
cmd vgcreate -q vgdaten $A $B
step "3. Belegung: pvs und vgs (Gerätenamen ausgeblendet)"
pvs --units m -o pv_name,vg_name,pv_size,pv_free,pv_pe_count --noheadings | sed -E 's#/dev/loop[0-9]+#/dev/loopX#' | sort
vgs --units m -o vg_name,pv_count,lv_count,vg_size,vg_free,vg_extent_size,vg_extent_count --noheadings
step "4. Eine dritte Platte in die Gruppe aufnehmen (vgextend)"
img_loop c 100M; C=$DEV
cmd pvcreate -q $C
cmd vgextend -q vgdaten $C
vgs --units m -o vg_name,pv_count,vg_size,vg_free --noheadings
step "5. Einen Logical Volume anlegen: im Container nicht möglich (kein Device-Mapper)"
lvcreate -L 100M -n lv1 vgdaten 2>&1 | head -3
step "6. Aufräumen"
vgremove -qf vgdaten >/dev/null 2>&1; pvremove -qf $A $B $C >/dev/null 2>&1; echo "VG und PVs entfernt"
lab_down
