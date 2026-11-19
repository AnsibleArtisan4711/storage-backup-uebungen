#!/usr/bin/env python3
"""Rechnet Speicherbedarf und Wiederherstellungskette für voll, inkrementell und differenziell.

Aufruf:  python sicherungsarten.py [--daten-gb 500] [--aenderung-prozent 3] [--tage 7]
Modell (Vereinfachung dieses Kurses): Jeden Tag ändern sich aenderung-prozent der Daten, und zwar jeden Tag
andere Dateien (Überschneidungen werden nicht berücksichtigt). Tag 0 = Vollsicherung.
  inkrementell: Tag k sichert nur die Änderungen seit Tag k-1.
  differenziell: Tag k sichert alle Änderungen seit der Vollsicherung (k Tage).
"""
import argparse


def rechne(daten, prozent, tage):
    tagwert = daten * prozent / 100.0
    inkr = [tagwert] * tage
    diff = [tagwert * k for k in range(1, tage + 1)]
    return tagwert, inkr, diff


def main():
    p = argparse.ArgumentParser()
    p.add_argument('--daten-gb', type=float, default=500)
    p.add_argument('--aenderung-prozent', type=float, default=3)
    p.add_argument('--tage', type=int, default=7)
    a = p.parse_args()
    tagwert, inkr, diff = rechne(a.daten_gb, a.aenderung_prozent, a.tage)
    voll_woche = a.daten_gb * (a.tage + 1)
    print('Daten: %.0f GB, Änderung: %.1f %% pro Tag (%.1f GB), Zyklus: 1 Voll + %d Tage' % (
        a.daten_gb, a.aenderung_prozent, tagwert, a.tage))
    print()
    print('%-14s %12s %14s %24s' % ('Strategie', 'Zyklus (GB)', 'Letzter Tag', 'Wiederherstellung am letzten Tag'))
    print('%-14s %12.1f %14s %24s' % ('nur voll', voll_woche, '%.1f GB' % a.daten_gb, '1 Satz (1 Voll)'))
    print('%-14s %12.1f %14s %24s' % ('inkrementell', a.daten_gb + sum(inkr), '%.1f GB' % inkr[-1],
                                    '%d Sätze (1 Voll + %d Inkr.)' % (1 + a.tage, a.tage)))
    print('%-14s %12.1f %14s %24s' % ('differenziell', a.daten_gb + sum(diff), '%.1f GB' % diff[-1],
                                    '2 Sätze (1 Voll + 1 Diff.)'))
    print()
    print('Tag  inkrementell(GB)  differenziell(GB)')
    for k in range(a.tage):
        print('%3d  %16.1f  %17.1f' % (k + 1, inkr[k], diff[k]))


if __name__ == '__main__':
    main()
