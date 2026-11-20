#!/usr/bin/env python3
"""Hilfsmodell: Welcher Snapshot dient als gemeinsame Basis für eine inkrementelle Übertragung?
Eingabe: Snapshot-Namen auf Quelle und Ziel (nach Zeit sortiert). Ausgabe: Befehle als TEXT (werden NICHT ausgeführt).
Die ZFS-Zeilen stammen aus Fachwissen und sind nicht bestätigt. Aufruf: python3 replikationsplan.py"""

def plan(quelle, ziel, btrfs_pfad='/mnt/q/.snap', ziel_pfad='/mnt/z/sicherung', zfs_quelle='tank/daten', zfs_ziel='backup/daten'):
    gemeinsam = [s for s in quelle if s in ziel]
    neu = [s for s in quelle if s not in ziel]
    if not neu:
        return ['Nichts zu übertragen: Ziel hat bereits alle Snapshots.']
    zeilen = []
    basis = gemeinsam[-1] if gemeinsam else None
    if basis is None:
        zeilen.append('Keine gemeinsame Basis: vollständige Übertragung des ersten neuen Snapshots, danach inkrementell')
    for s in neu:
        if basis is None:
            zeilen.append(f'btrfs send {btrfs_pfad}/{s} | btrfs receive {ziel_pfad}')
            zeilen.append(f'zfs send {zfs_quelle}@{s} | zfs receive {zfs_ziel}')
        else:
            zeilen.append(f'btrfs send -p {btrfs_pfad}/{basis} {btrfs_pfad}/{s} | btrfs receive {ziel_pfad}')
            zeilen.append(f'zfs send -i @{basis} {zfs_quelle}@{s} | zfs receive {zfs_ziel}')
        basis = s
    return zeilen

if __name__ == '__main__':
    fälle = {
        'Normalfall': (['s1', 's2', 's3', 's4'], ['s1', 's2']),
        'Ziel leer (Erstübertragung)': (['s1', 's2'], []),
        'Ziel aktuell': (['s1', 's2'], ['s1', 's2']),
        'Basis auf der Quelle gelöscht': (['s3', 's4'], ['s1', 's2']),
    }
    for name, (q, z) in fälle.items():
        print(f'--- {name}: Quelle {q}, Ziel {z}')
        for z_ in plan(q, z):
            print('   ', z_)
