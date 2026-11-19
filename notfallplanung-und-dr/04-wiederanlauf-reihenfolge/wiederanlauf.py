#!/usr/bin/env python3
"""Wiederanlauf-Reihenfolge aus Abhängigkeiten (topologische Sortierung, Standardbibliothek graphlib).
Zeigt: Reihenfolge in Stufen, parallel startbare Systeme, kumulierte Dauer bei einem Admin bzw. parallelem Arbeiten, RTO-Verstöße.
Aufruf: python3 wiederanlauf.py abhaengigkeiten.csv [Zahl_Helfer, Standard 1]"""
import csv, sys
from graphlib import TopologicalSorter, CycleError
z = {r["system"]: r for r in csv.DictReader(open(sys.argv[1], encoding="utf-8"), delimiter=";")}
helfer = int(sys.argv[2]) if len(sys.argv) > 2 else 1
g = {s: [d for d in r["haengt_ab_von"].split(",") if d] for s, r in z.items()}
for s, deps in g.items():
    for d in deps:
        if d not in z: sys.exit("Unbekannte Abhängigkeit %s bei %s" % (d, s))
ts = TopologicalSorter(g)
try: ts.prepare()
except CycleError as e: sys.exit("Zyklus in den Abhängigkeiten: %s" % e.args[1])
uhr = [0.0] * helfer           # Zeitpunkt, an dem jeder Helfer frei ist
fertig = {}
stufe = 0
print("Helfer: %d" % helfer)
while ts.is_active():
    bereit = sorted(ts.get_ready(), key=lambda s: float(z[s]["rto_h"]))
    stufe += 1
    print("Stufe %d: %s" % (stufe, ", ".join(bereit)))
    for s in bereit:
        frei = min(range(helfer), key=lambda i: uhr[i])
        start = max(uhr[frei], max([fertig[d] for d in g[s]] or [0]))
        fertig[s] = start + float(z[s]["wiederherstellung_min"])
        uhr[frei] = fertig[s]
        ts.done(s)
print("\n%-9s %-26s %10s %8s  %s" % ("System", "hängt ab von", "fertig nach", "RTO", "Ergebnis"))
bad = 0
for s in sorted(fertig, key=fertig.get):
    h = fertig[s] / 60; ok = h <= float(z[s]["rto_h"]); bad += not ok
    print("%-9s %-26s %8.1f h %6g h  %s" % (s, z[s]["haengt_ab_von"] or "-", h, float(z[s]["rto_h"]), "ok" if ok else "RTO VERFEHLT"))
print("\nGesamtdauer: %.1f h; %d von %d Systemen verfehlen den RTO." % (max(fertig.values()) / 60, bad, len(z)))
sys.exit(1 if bad else 0)   # Rückgabewert 1, wenn mindestens ein RTO verfehlt wird
