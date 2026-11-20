#!/usr/bin/env bash
# Ein ganzes Subvolume auf einen Snapshot zurücksetzen (Rollback) durch Austausch des Subvolumes (Loop-Gerät, erfundene Daten).
cd "$(dirname "$0")" || exit 1
. ../lab.sh
lab_up; img_loop a 300M; mkfs.btrfs -q -f $DEV; mount $DEV $W/mnt; cd $W/mnt
btrfs subvolume create daten >/dev/null; mkdir .snap
echo "Konfiguration Stand 1" > daten/config.txt; echo "Datenbestand 1" > daten/daten.txt
btrfs subvolume snapshot -r daten .snap/stand1 >/dev/null
step "1. Fehlerhafte Änderung (z. B. misslungenes Update)"
echo "KAPUTT" > daten/config.txt; rm daten/daten.txt; echo "Müll" > daten/zufall.txt
ls daten
step "2. Rollback: beschreibbaren Klon des Snapshots anlegen und das alte Subvolume ersetzen"
cmd btrfs subvolume snapshot .snap/stand1 daten-neu
cmd mv daten daten-defekt
cmd mv daten-neu daten
ls daten; cat daten/config.txt
step "3. Das defekte Subvolume sichern (zur Analyse) oder löschen"
btrfs subvolume list . | sed 's/gen [0-9]* //'
cmd btrfs subvolume delete daten-defekt
step "4. Alternative: Standard-Subvolume wechseln (btrfs subvolume set-default), das gebootet bzw. eingebunden wird"
ID=$(btrfs subvolume show .snap/stand1 | awk '/Subvolume ID:/{print $3}')
echo "ID des Snapshots stand1: $ID"
echo "Befehl (Beispiel, hier nicht ausgeführt): btrfs subvolume set-default $ID /Einhängepunkt"
step "5. Wichtig: Der Snapshot bleibt unverändert und kann weiter als Rückfallpunkt dienen"
btrfs subvolume list . | sed 's/gen [0-9]* //'
cat .snap/stand1/config.txt
cd /; lab_down
