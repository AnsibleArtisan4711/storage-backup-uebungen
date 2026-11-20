#!/usr/bin/env python3
"""Welche Snapshots werden behalten? Aufbewahrungsregel: letzte N tägliche, M wöchentliche (Sonntag), K monatliche (1. des Monats).
Eigenes Modell mit erfundenen Zeitpunkten; kein Werkzeug von Btrfs oder ZFS. Aufruf: python3 rotation.py"""
from datetime import date, timedelta

def behalten(snaps, heute, taeglich=7, woechentlich=4, monatlich=6):
    keep = set()
    ordnen = sorted(snaps, reverse=True)
    keep.update(s for s in ordnen if (heute - s).days < taeglich)                                   # letzte N Tage: alle
    sonntage = [s for s in ordnen if s.weekday() == 6]
    keep.update(sonntage[:woechentlich])
    erste = [s for s in ordnen if s.day == 1]
    keep.update(erste[:monatlich])
    return keep

if __name__ == '__main__':
    heute = date(2026, 11, 20)
    snaps = [heute - timedelta(days=i) for i in range(0, 200)]      # täglich ein Snapshot, 200 Tage
    keep = behalten(snaps, heute)
    print(f'Snapshots vorhanden: {len(snaps)}, behalten: {len(keep)}, löschen: {len(snaps) - len(keep)}')
    print('behalten (neueste zuerst):')
    for s in sorted(keep, reverse=True):
        grund = []
        if (heute - s).days < 7: grund.append('täglich')
        if s.weekday() == 6: grund.append('Sonntag')
        if s.day == 1: grund.append('Monatserster')
        print(f'  {s}  ({", ".join(grund)})')
    print('\nLücke-Test: fehlt der letzte Snapshot (Sicherung ausgefallen)?')
    ohne = [s for s in snaps if s != heute]
    k2 = behalten(ohne, heute)
    print(f'  neuester behaltener Snapshot: {max(k2)} (Alter {(heute - max(k2)).days} Tag)')
