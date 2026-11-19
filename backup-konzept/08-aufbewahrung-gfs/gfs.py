#!/usr/bin/env python3
"""Aufbewahrung nach Großvater-Vater-Sohn (GFS): Simulation ohne Zusatzpakete.
Aufruf: python3 gfs.py [Tage] [taeglich] [woechentlich] [monatlich]
Regel: eine Sicherung pro Tag; behalten werden die letzten N Tage, die letzten W Wochen (je letzter Stand der Woche)
und die letzten M Monate (je letzter Stand des Monats). Alles andere wird gelöscht."""
import sys, datetime as dt

tage = int(sys.argv[1]) if len(sys.argv) > 1 else 400
D, W, M = (int(x) for x in sys.argv[2:5]) if len(sys.argv) > 4 else (7, 4, 12)
start = dt.date(2026, 1, 1)
alle = [start + dt.timedelta(days=i) for i in range(tage)]

def letzte_je(gruppe, anzahl):
    """letzte Sicherung je Gruppe (Woche/Monat), neueste 'anzahl' Gruppen"""
    best = {}
    for d in alle:
        best[gruppe(d)] = d
    return set(best[k] for k in sorted(best)[-anzahl:])

keep = set(alle[-D:]) | letzte_je(lambda d: d.isocalendar()[:2], W) | letzte_je(lambda d: (d.year, d.month), M)
print("Sicherungen erstellt:      %d (eine pro Tag, %s bis %s)" % (len(alle), alle[0], alle[-1]))
print("Regel:                     %d täglich, %d wöchentlich, %d monatlich" % (D, W, M))
print("Behalten:                  %d" % len(keep))
print("Gelöscht:                  %d" % (len(alle) - len(keep)))
print("Ältester behaltener Stand: %s (%d Tage zurück)" % (min(keep), (alle[-1] - min(keep)).days))
print()
print("Behaltene Stände (neueste zuerst):")
for d in sorted(keep, reverse=True):
    art = []
    if d in alle[-D:]: art.append("täglich")
    if d in letzte_je(lambda x: x.isocalendar()[:2], W): art.append("wöchentlich")
    if d in letzte_je(lambda x: (x.year, x.month), M): art.append("monatlich")
    print("  %s  %s" % (d, ", ".join(art)))
