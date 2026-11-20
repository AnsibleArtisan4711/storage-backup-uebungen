#!/usr/bin/env bash
# Gemeinsame Hilfen der Übungsreihe (P54). Nur im Testlabor als root ausführen.
# Es werden Image-Dateien unter /tmp/p54 angelegt, als Loop-Geräte eingebunden und am Ende wieder entfernt.
W=/tmp/p54
step() { echo; echo "## $*"; }
cmd() { echo "\$ $*"; "$@" 2>&1; return $?; }
lab_up() { lab_down >/dev/null 2>&1; mkdir -p "$W/mnt"; }
# Image anlegen und als Loop-Gerät einbinden; Gerätename steht danach in $DEV
img_loop() { truncate -s "$2" "$W/$1.img"; DEV=$(losetup -f --show "$W/$1.img"); }
lab_down() {
  for m in $(mount | awk -v w="$W" '$3 ~ w {print $3}' | sort -r); do umount "$m" 2>/dev/null; done
  for l in $(losetup -a | grep "$W" | cut -d: -f1); do losetup -d "$l"; done
  rm -rf "$W"
}
