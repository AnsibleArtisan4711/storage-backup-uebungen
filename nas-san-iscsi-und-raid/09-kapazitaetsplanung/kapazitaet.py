#!/usr/bin/env python3
"""Kapazitätsplanung: nutzbare Kapazität je RAID-Stufe, Wachstum, Dateisystem-Reserve und Zeitpunkt der Füllung.
Alle Zahlen sind ERFUNDENE Annahmen (Datenbestand, Wachstum, Reserve) und keine Messwerte."""
import math, sys

def nutzbar(stufe, n, tb):
    return {0: n * tb, 1: tb, 5: (n - 1) * tb, 6: (n - 2) * tb, 10: n // 2 * tb}[stufe]

bestand_tb = 9.0           # Annahme: heutiger Datenbestand in TB
wachstum_prozent = 25      # Annahme: Wachstum pro Jahr
reserve = 0.20             # Annahme: 20 % frei lassen (Dateisystem, Snapshots, Rebuild-Reserve)
n, tb = 6, 4               # Annahme: 6 Platten zu 4 TB

print(f"Bestand {bestand_tb} TB, Wachstum {wachstum_prozent} %/Jahr, Reserve {reserve:.0%}, {n} Platten zu {tb} TB")
print(f"{'Stufe':8} {'nutzbar TB':>10} {'ohne Reserve':>12} {'Jahre bis voll':>14}")
for s in (5, 6, 10):
    nb = nutzbar(s, n, tb); nutz = nb * (1 - reserve)
    jahre = math.log(nutz / bestand_tb) / math.log(1 + wachstum_prozent / 100) if nutz > bestand_tb else 0
    print(f"RAID {s:<3} {nb:>10} {nutz:>12.1f} {jahre:>14.1f}")
print()
print("Bestand je Jahr (RAID 6, mit Reserve gerechnet):")
nutz = nutzbar(6, n, tb) * (1 - reserve)
b = bestand_tb
for j in range(0, 6):
    zeile = f"  Jahr {j}: {b:5.1f} TB von {nutz:.1f} TB ({b/nutz:4.0%})"
    if b > nutz: zeile += "  <- voll"
    print(zeile); b *= 1 + wachstum_prozent / 100
print()
print("Thin Provisioning (Modell): 10 Freigaben zu je 2 TB zugesagt =", 10 * 2, "TB; tatsächlich belegt je Freigabe 0,9 TB =", round(10 * 0.9, 1), "TB.")
print("Überzeichnung:", f"{10*2/nutz:.1f}x der nutzbaren Kapazität. Das geht nur gut, solange die Belegung überwacht wird.")
