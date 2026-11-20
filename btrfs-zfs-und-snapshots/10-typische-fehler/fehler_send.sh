#!/usr/bin/env bash
# Typische Fehler bei send/receive: nicht schreibgeschützt, Elternsnapshot fehlt, Name existiert schon (Loop-Geräte, erfundene Daten).
cd "$(dirname "$0")" || exit 1
. ../lab.sh
lab_up; img_loop q 200M; Q=$DEV; img_loop z 200M; Z=$DEV
mkfs.btrfs -q -f $Q; mkfs.btrfs -q -f $Z; mkdir -p $W/q $W/z; mount $Q $W/q; mount $Z $W/z; mkdir $W/q/.snap $W/z/sicherung
btrfs subvolume create $W/q/daten >/dev/null; echo "Version 1" > $W/q/daten/n.txt
step "1. Fehler: Snapshot ohne -r (beschreibbar) lässt sich nicht senden"
btrfs subvolume snapshot $W/q/daten $W/q/.snap/s1 >/dev/null
btrfs send -f $W/x.strom $W/q/.snap/s1 2>&1 | sed "s#$W#/tmp/p34#g"
echo "Lösung: schreibgeschützten Snapshot anlegen (btrfs subvolume snapshot -r)."
btrfs subvolume delete $W/q/.snap/s1 >/dev/null
step "2. Normalfall: s1 voll, s2 inkrementell senden"
btrfs subvolume snapshot -r $W/q/daten $W/q/.snap/s1 >/dev/null
echo "Version 2" > $W/q/daten/n.txt; btrfs subvolume snapshot -r $W/q/daten $W/q/.snap/s2 >/dev/null
btrfs send -q -f $W/s1.strom $W/q/.snap/s1; btrfs send -q -p $W/q/.snap/s1 -f $W/s2.strom $W/q/.snap/s2
btrfs receive -q -f $W/s1.strom $W/z/sicherung; echo "s1 empfangen: $(ls $W/z/sicherung)"
step "3. Fehler: Elternsnapshot fehlt im Ziel (s1 dort gelöscht) beim Empfang von s2"
btrfs subvolume delete $W/z/sicherung/s1 >/dev/null
btrfs receive -f $W/s2.strom $W/z/sicherung 2>&1 | sed "s#$W#/tmp/p34#g"
echo "Lösung: Elternsnapshot im Ziel wiederherstellen (erneut vollständig senden) oder eine andere gemeinsame Basis wählen."
step "4. Fehler: der Name existiert im Ziel bereits"
btrfs receive -q -f $W/s1.strom $W/z/sicherung && echo "Erster Empfang gelingt (s1 ist wieder im Ziel). Zweiter Versuch mit demselben Namen:"
btrfs receive -f $W/s1.strom $W/z/sicherung 2>&1 | sed "s#$W#/tmp/p34#g" | head -2
echo "Lösung: Ziel-Snapshot zuerst umbenennen oder löschen, oder in einen anderen Ordner empfangen."
step "5. Elternsnapshot auf der Quelle gelöscht: inkrementelles Senden nicht mehr möglich"
btrfs subvolume delete $W/q/.snap/s1 >/dev/null
btrfs send -p $W/q/.snap/s1 -f $W/y.strom $W/q/.snap/s2 2>&1 | sed "s#$W#/tmp/p34#g" | head -2
cd /; lab_down
