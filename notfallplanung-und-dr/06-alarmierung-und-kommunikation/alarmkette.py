#!/usr/bin/env python3
"""Alarmkette simulieren: wer wird in welcher Reihenfolge angerufen, was passiert bei Nichterreichen (Vertretung)?
Aufruf: python3 alarmkette.py kontakte.csv [nicht_erreichbar,...]    (Namen durch Komma; Telefonnummern sind Beispielwerte)
Keine echten Anrufe: die Simulation prüft nur die Kette und zählt die Minuten (Annahme 5 min je Versuch)."""
import csv, sys
k = list(csv.DictReader(open(sys.argv[1], encoding="utf-8"), delimiter=";"))
weg = set(sys.argv[2].split(",")) if len(sys.argv) > 2 else set()
minute, fehl = 0, 0
print("Nicht erreichbar: %s\n" % (", ".join(sorted(weg)) or "niemand"))
for r in sorted(k, key=lambda r: int(r["stufe"])):
    versuche = [r["name"]] + ([r["vertretung"]] if r["vertretung"] else [])
    ergebnis = "NIEMAND ERREICHT"
    for v in versuche:
        minute += 5
        if v not in weg: ergebnis = "erreicht: %s (%s)" % (v, "Vertretung" if v != r["name"] else "Hauptperson"); break
    else: fehl += 1
    print("Stufe %s %-28s Minute %3d  %s" % (r["stufe"], r["rolle"], minute, ergebnis))
print("\nKette nach %d Minuten abgeschlossen, %d Stufe(n) ohne Ergebnis." % (minute, fehl))
if fehl: print("Befund: Lücke in der Kette. Vertretung benennen oder Rolle doppelt besetzen.")
