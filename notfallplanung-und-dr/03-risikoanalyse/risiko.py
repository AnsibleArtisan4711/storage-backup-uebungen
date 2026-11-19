#!/usr/bin/env python3
"""Risikomatrix: Risiko = Eintrittswahrscheinlichkeit x Schadenshöhe (je 1 bis 5), vor und nach Maßnahmen.
Aufruf: python3 risiko.py risiken.csv   Klassen: >=15 hoch, 8-14 mittel, <8 niedrig (Schwellen sind eine Annahme dieser Übung)."""
import csv, sys
def kl(x): return "hoch" if x >= 15 else "mittel" if x >= 8 else "niedrig"
z = list(csv.DictReader(open(sys.argv[1], encoding="utf-8"), delimiter=";"))
print("%-3s %-40s %6s %-7s %6s %-7s" % ("ID", "Szenario", "brutto", "Klasse", "netto", "Klasse"))
for r in sorted(z, key=lambda r: -int(r["wahrscheinlichkeit_1_5"]) * int(r["schaden_1_5"])):
    b = int(r["wahrscheinlichkeit_1_5"]) * int(r["schaden_1_5"]); n = int(r["restwahrscheinlichkeit_1_5"]) * int(r["restschaden_1_5"])
    print("%-3s %-40s %6d %-7s %6d %-7s%s" % (r["id"], r["szenario"], b, kl(b), n, kl(n), "  <- Wirkung der Maßnahme fraglich" if n >= b else ""))
print("\nMatrix netto (Zeilen Schaden 5..1, Spalten Wahrscheinlichkeit 1..5):")
m = {}
for r in z: m.setdefault((int(r["restschaden_1_5"]), int(r["restwahrscheinlichkeit_1_5"])), []).append(r["id"])
for s in range(5, 0, -1):
    print("S%d | " % s + " | ".join("%-8s" % ",".join(m.get((s, w), [])) for w in range(1, 6)))
print("     " + "   ".join("W%d      " % w for w in range(1, 6)))
