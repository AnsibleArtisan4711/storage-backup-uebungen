#!/usr/bin/env bash
# Gemeinsame Hilfen der Übungsreihe (P33). Nur im Testlabor als root ausführen.
# Es werden Image-Dateien unter /tmp/p33 angelegt, als Loop-Geräte eingebunden und am Ende wieder entfernt.
# Der iSCSI-Target-Dienst (tgtd) läuft ohne systemd im Vordergrundmodus auf 127.0.0.1:3260.
W=/tmp/p33
PORTAL=127.0.0.1:3260
IQN_T=iqn.2026-11.example.com:lab.ziel1
IQN_I=iqn.2026-11.example.com:lab.init1
step() { echo; echo "## $*"; }
cmd() { echo "\$ $*"; "$@" 2>&1; return $?; }
lab_up() { lab_down >/dev/null 2>&1; mkdir -p "$W/mnt"; }
# Image anlegen und als Loop-Gerät einbinden; Gerätename steht danach in $DEV
img_loop() { truncate -s "$2" "$W/$1.img"; DEV=$(losetup -f --show "$W/$1.img"); }
tgt_up() {
  (tgtd -f --iscsi portal=$PORTAL </dev/null >"$W/tgtd.log" 2>&1 &)
  for i in $(seq 1 30); do tgtadm --lld iscsi --mode target --op show >/dev/null 2>&1 && break; sleep 0.2; done
}
tgt_down() {
  pkill -x tgtd 2>/dev/null
  for i in $(seq 1 10); do pgrep -x tgtd >/dev/null || return 0; sleep 0.2; done
  pkill -9 -x tgtd 2>/dev/null
  for i in $(seq 1 20); do pgrep -x tgtd >/dev/null || return 0; sleep 0.2; done
}
lab_down() {
  tgt_down
  for m in $(mount | awk -v w="$W" '$3 ~ w {print $3}'); do umount "$m"; done
  for l in $(losetup -a | grep "$W" | cut -d: -f1); do losetup -d "$l"; done
  rm -rf "$W"
}
