#!/usr/bin/env python3
"""Ordnet Fehlermeldungen (Textzeilen) möglichen Ursachen und nächsten Schritten zu.
Die Muster stammen aus Meldungen, die in den Läufen dieser Übungsreihe auftraten, und aus Fachwissen (Ursachen sind Vermutungen, keine Gewissheit).
Aufruf: python3 diagnose.py DATEI   (liest Zeilen) """
import re, sys

REGELN = [
    (r'No space left on device', 'Platz oder Metadaten aufgebraucht',
     'Snapshots prüfen (`btrfs subvolume list -s`), `btrfs filesystem usage` lesen (Unallocated), Snapshots löschen, ggf. Balance'),
    (r'Disk quota exceeded', 'Quote (qgroup) des Subvolumes erreicht',
     '`btrfs qgroup show -re` lesen, Grenze prüfen oder Daten entfernen'),
    (r'Read-only file system', 'schreibgeschützter Snapshot oder Dateisystem wurde schreibgeschützt eingebunden',
     'Ziel prüfen (Snapshot?), bei Dateisystemfehlern Protokoll lesen (`dmesg`)'),
    (r'Input/output error', 'Lesefehler, bei Btrfs oft ein Prüfsummenfehler ohne Kopie zum Reparieren',
     '`dmesg` auf `csum failed` prüfen, Scrub ausführen, Datei aus der Sicherung wiederherstellen'),
    (r'csum failed', 'Prüfsumme stimmt nicht: Daten oder Datenträger beschädigt',
     '`btrfs scrub start`, `btrfs device stats`, Zustand der Platte prüfen (SMART)'),
    (r'errors detected during scrubbing, corrected', 'Scrub hat Fehler erkannt und aus der Kopie repariert',
     'Fehlerzähler beobachten (`btrfs device stats`); häufen sich Fehler, Platte tauschen'),
    (r'is not read-only', 'Snapshot ohne `-r` angelegt; `btrfs send` braucht schreibgeschützte Subvolumes',
     'Snapshot mit `btrfs subvolume snapshot -r` neu anlegen'),
    (r'cannot find parent subvolume', 'Elternsnapshot fehlt im Ziel; inkrementeller Datenstrom passt nicht',
     'Gemeinsame Basis prüfen (`replikationsplan.py`), sonst vollständig neu senden'),
    (r'failed: File exists', 'Name im Ziel existiert bereits', 'Ziel-Snapshot umbenennen oder löschen, oder anderes Zielverzeichnis wählen'),
    (r"quotas not enabled", 'Quoten sind für dieses Dateisystem nicht eingeschaltet', '`btrfs quota enable` ausführen (wenn Quoten gewollt sind)'),
    (r'open_ctree failed|mount\(2\) system call failed', 'Dateisystem lässt sich nicht einbinden, z. B. fehlendes Gerät',
     '`btrfs filesystem show`, fehlende Platte prüfen, Notfalls `-o degraded` (nur zur Datensicherung/Reparatur)'),
    (r'Multiple block group profiles detected', 'unterschiedliche Profile (z. B. single und raid1) nebeneinander, oft nach degradiertem Betrieb',
     '`btrfs balance start -dconvert=raid1,soft -mconvert=raid1,soft`'),
]

def main(pfad):
    erkannt = unbekannt = 0
    for z in open(pfad, encoding='utf-8'):
        z = z.rstrip('\n')
        if not z or z.startswith('#'):
            continue
        for muster, ursache, schritt in REGELN:
            if re.search(muster, z):
                print(f'Meldung: {z[:90]}\n   Ursache (vermutet): {ursache}\n   Nächster Schritt:   {schritt}'); erkannt += 1; break
        else:
            print(f'Meldung: {z[:90]}\n   UNBEKANNT: nicht in der Regelliste; Dokumentation und Protokolle lesen'); unbekannt += 1
    print(f'\n{erkannt} erkannt, {unbekannt} unbekannt')
    return 1 if unbekannt else 0

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print(__doc__); sys.exit(2)
    sys.exit(main(sys.argv[1]))
