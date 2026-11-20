#!/usr/bin/env python3
"""Modell (NICHT ZFS selbst): Snapshots, Klone und Platzabrechnung nach dem ZFS-Prinzip (Fachwissen, nicht bestätigt).
Ein Dataset besteht aus Blöcken; ein Snapshot merkt sich die Blockmenge. Platz „used“ eines Snapshots = nur Blöcke, die allein er noch hält.
Erfundene Größen in MB. Aufruf: python3 zfs_snapshots_modell.py"""

class Dataset:
    def __init__(self, name):
        self.name = name
        self.blocks = {}          # id -> MB
        self.snaps = {}           # name -> Menge von Block-IDs
        self.n = 0
    def schreibe(self, anzahl_mb):
        for _ in range(anzahl_mb):
            self.n += 1; self.blocks[f'{self.name}#{self.n}'] = 1
    def lösche_blocks(self, ids):
        for b in ids:
            self.blocks.pop(b, None)
    def snapshot(self, name):
        self.snaps[name] = set(self.blocks)
    def used_by_snapshot(self, name):
        andere = set(self.blocks)
        for n, s in self.snaps.items():
            if n != name: andere |= s
        return len(self.snaps[name] - andere)
    def belegt(self):
        alle = set(self.blocks)
        for s in self.snaps.values(): alle |= s
        return len(alle)

if __name__ == '__main__':
    d = Dataset('tank/daten')
    d.schreibe(100); d.snapshot('s1')
    print(f'Nach 100 MB und Snapshot s1: Dataset {len(d.blocks)} MB, s1 used {d.used_by_snapshot("s1")} MB, insgesamt belegt {d.belegt()} MB')
    d.lösche_blocks(list(d.blocks)[:40]); d.schreibe(10)
    print(f'Nach Löschen von 40 MB und Schreiben von 10 MB: Dataset {len(d.blocks)} MB, s1 used {d.used_by_snapshot("s1")} MB, insgesamt belegt {d.belegt()} MB')
    d.snapshot('s2')
    d.lösche_blocks(list(d.blocks)[:30])
    print(f'Nach s2 und Löschen von 30 MB: Dataset {len(d.blocks)} MB; s1 used {d.used_by_snapshot("s1")}, s2 used {d.used_by_snapshot("s2")}; belegt {d.belegt()} MB')
    del d.snaps['s1']
    print(f'Nach Löschen von s1: s2 used {d.used_by_snapshot("s2")} MB, insgesamt belegt {d.belegt()} MB')
    print('\nKlon: ein Klon entsteht aus einem Snapshot und teilt alle Blöcke, bis er sie ändert:')
    k = Dataset('tank/klon'); k.blocks = {b: 1 for b in d.snaps['s2']}
    gemeinsam = len(set(k.blocks) & d.snaps['s2'])
    print(f'  Klon aus s2: {len(k.blocks)} MB sichtbar, davon gemeinsam mit s2: {gemeinsam} MB, eigener Platz: {len(k.blocks) - gemeinsam} MB')
    k.schreibe(5)
    print(f'  Nach 5 MB Schreiben im Klon: eigener Platz {len(set(k.blocks) - d.snaps["s2"])} MB')
