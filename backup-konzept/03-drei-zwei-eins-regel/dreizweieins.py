#!/usr/bin/env python3
"""Prüft ein Kopienverzeichnis gegen die 3-2-1-Regel und die Erweiterung 3-2-1-1-0.

Aufruf:  python dreizweieins.py kopien.csv [--heimat standort-a]
Spalten: daten, kopie (0 = Produktivdaten), medium, ort, offline_oder_unveraenderlich (ja/nein),
         letzter_test (ok / fehler / - für noch nie getestet oder nicht zutreffend)
Auslegung dieses Kurses:
  3  = mindestens drei Kopien insgesamt (Produktivdaten zählen mit)
  2  = mindestens zwei verschiedene Medientypen
  1  = mindestens eine Kopie an einem anderen Ort als die Produktivdaten
  +1 = mindestens eine Kopie offline oder unveränderlich
  0  = keine Fehler beim letzten Wiederherstellungstest der Sicherungskopien
"""
import argparse
import csv
from collections import defaultdict


def pruefe(zeilen, heimat):
    gruppen = defaultdict(list)
    for z in zeilen:
        gruppen[z['daten']].append(z)
    ergebnis = []
    for daten, kopien in gruppen.items():
        sicherungen = [k for k in kopien if k['kopie'] != '0']
        r = {
            'daten': daten,
            'drei': len(kopien) >= 3,
            'zwei': len({k['medium'] for k in kopien}) >= 2,
            'eins': any(k['ort'] != heimat for k in sicherungen),
            'plus_eins': any(k['offline_oder_unveraenderlich'] == 'ja' for k in sicherungen),
            'null': bool(sicherungen) and all(k['letzter_test'] == 'ok' for k in sicherungen),
        }
        r['anzahl'] = len(kopien)
        ergebnis.append(r)
    return ergebnis


def main():
    p = argparse.ArgumentParser()
    p.add_argument('datei')
    p.add_argument('--heimat', default='standort-a', help='Ort der Produktivdaten')
    a = p.parse_args()
    with open(a.datei, newline='', encoding='utf-8') as f:
        zeilen = list(csv.DictReader(f))
    ergebnis = pruefe(zeilen, a.heimat)
    j = lambda b: 'ja ' if b else 'NEIN'
    print('%-24s %6s %4s %4s %4s %5s %4s  %s' % ('Daten', 'Kopien', '3', '2', '1', '+1', '0', 'Stufe'))
    for r in ergebnis:
        if r['drei'] and r['zwei'] and r['eins']:
            stufe = '3-2-1-1-0' if (r['plus_eins'] and r['null']) else '3-2-1'
        else:
            stufe = 'nicht erfüllt'
        print('%-24s %6d %4s %4s %4s %5s %4s  %s' % (
            r['daten'], r['anzahl'], j(r['drei']), j(r['zwei']), j(r['eins']), j(r['plus_eins']), j(r['null']), stufe))
    # Rückgabewert 1, wenn mindestens ein System die Regel 3-2-1 nicht erfüllt (für Monitoring)
    return 0 if all(r['drei'] and r['zwei'] and r['eins'] for r in ergebnis) else 1


if __name__ == '__main__':
    import sys
    sys.exit(main())
