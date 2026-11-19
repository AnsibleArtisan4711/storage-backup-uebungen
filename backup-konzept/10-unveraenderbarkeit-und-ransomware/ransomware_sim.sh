#!/bin/bash
# Laborsimulation: Was überlebt, wenn Produktivdaten "verschlüsselt" werden und das Ziel schreibbar ist?
# Alles passiert nur im Arbeitsordner. Die "Schadsoftware" ist ein Einzeiler, der Dateien im Ordner produktiv/ überschreibt.
# Aufruf: bash ransomware_sim.sh [Arbeitsordner]     (benötigt root für chattr +i)
set -u
W="${1:-./lab10}"; rm -rf "$W"; mkdir -p "$W/produktiv" "$W/ziel_offen" "$W/ziel_geschuetzt" && cd "$W"
case "$PWD" in /tmp/*|"$HOME"/*|/home/*) ;; *) echo "Abbruch: Arbeitsordner liegt nicht unter /tmp oder /home"; exit 1;; esac
for i in 1 2 3; do echo "Wichtige Daten $i" > produktiv/akte$i.txt; done
sicher() { rsync -a --delete produktiv/ "$1/"; }
echo "== Sicherung auf beide Ziele"
sicher ziel_offen; sicher ziel_geschuetzt
# Geschütztes Ziel: unveränderlich (chattr +i) – Dateien und Ordner
chattr -R +i ziel_geschuetzt 2>&1 && echo "chattr +i gesetzt auf ziel_geschuetzt"
lsattr -d ziel_geschuetzt ziel_geschuetzt/akte1.txt | awk '{print $1, $2}'
echo "== 'Angriff': Produktivdaten werden überschrieben und umbenannt"
for f in produktiv/*.txt; do head -c 64 /dev/urandom | base64 > "$f.locked"; rm "$f"; done
ls produktiv
echo "== Die nächste planmäßige Sicherung läuft (Spiegel mit --delete) und verbreitet den Schaden"
sicher ziel_offen
echo "ziel_offen:"; ls ziel_offen
echo "ziel_geschuetzt:"; sicher ziel_geschuetzt 2>&1 | head -n 3; ls ziel_geschuetzt
echo "== Löschversuch auf dem geschützten Ziel (auch als root)"
rm -f ziel_geschuetzt/akte1.txt 2>&1; echo "Rückgabewert rm: $?"
echo "== Wiederherstellung aus dem geschützten Ziel"
mkdir wiederhergestellt && cp -a ziel_geschuetzt/akte*.txt wiederhergestellt/ && cat wiederhergestellt/akte1.txt
echo "== Aufräumen (Attribut entfernen, sonst lässt sich der Ordner nicht löschen)"
chattr -R -i ziel_geschuetzt && echo "chattr -i ok"
