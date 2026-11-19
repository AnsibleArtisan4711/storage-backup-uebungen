#!/usr/bin/env python3
"""Prüft, ob Sicherungsintervall und Wiederherstellungsdauer die Ziele RPO und RTO einhalten.

Aufruf:  python rpo_rto.py systeme.csv
Spalten: system, beschreibung, daten_gb, sicherungsintervall_h, rpo_ziel_h, rto_ziel_h,
         restore_mb_pro_s, vorarbeit_h
Modell (Vereinfachung dieses Kurses, keine Garantie):
  - Schlimmstfall des Datenverlusts = Sicherungsintervall (Ausfall kurz vor der nächsten Sicherung).
  - Wiederherstellungsdauer = Daten / Durchsatz + Vorarbeit (Server bereitstellen, Medium holen, Dienst prüfen).
"""
import csv
import sys


def lies(pfad):
    with open(pfad, newline='', encoding='utf-8') as f:
        return list(csv.DictReader(f))


def bewerte(z):
    gb = float(z['daten_gb'])
    mbs = float(z['restore_mb_pro_s'])
    restore_h = gb * 1024 / mbs / 3600 + float(z['vorarbeit_h'])
    verlust_h = float(z['sicherungsintervall_h'])
    rpo_ok = verlust_h <= float(z['rpo_ziel_h'])
    rto_ok = restore_h <= float(z['rto_ziel_h'])
    return verlust_h, restore_h, rpo_ok, rto_ok


def main(pfad):
    zeilen = lies(pfad)
    print('%-8s %8s %9s %9s %9s %9s  %s' % ('System', 'Intervall', 'RPO-Ziel', 'Restore_h', 'RTO-Ziel', 'RPO', 'RTO'))
    verletzt = 0
    for z in zeilen:
        verlust, restore, rpo_ok, rto_ok = bewerte(z)
        print('%-8s %8.1f h %7.1f h %7.2f h %7.1f h  %-4s %s' % (
            z['system'], verlust, float(z['rpo_ziel_h']), restore, float(z['rto_ziel_h']),
            'ok' if rpo_ok else 'NEIN', 'ok' if rto_ok else 'NEIN'))
        if not (rpo_ok and rto_ok):
            verletzt += 1
    print()
    print('%d von %d Systemen verfehlen mindestens ein Ziel.' % (verletzt, len(zeilen)))
    return 1 if verletzt else 0


if __name__ == '__main__':
    if len(sys.argv) != 2:
        print(__doc__)
        sys.exit(2)
    sys.exit(main(sys.argv[1]))
