#!/usr/bin/env python3
"""Business-Impact-Analyse: Prozesse nach Dringlichkeit ordnen und Plausibilität prüfen.
Aufruf: python3 bia.py prozesse.csv
Regeln: RTO muss kleiner als MTPD sein; Prioritätsklasse aus RTO: <=4 h A, <=12 h B, <=48 h C, sonst D.
Schaden bis zum RTO = Ausfallkosten/h x RTO (Näherung, ohne Folgeschäden)."""
import csv, sys
KLASSEN = [(4, "A"), (12, "B"), (48, "C")]
def klasse(rto):
    for g, k in KLASSEN:
        if rto <= g: return k
    return "D"
zeilen = list(csv.DictReader(open(sys.argv[1], encoding="utf-8"), delimiter=";"))
fehler = 0
print("%-22s %-7s %5s %5s %5s %-6s %12s" % ("Prozess", "System", "RTO h", "MTPD", "RPO h", "Klasse", "Schaden bis RTO"))
for z in sorted(zeilen, key=lambda z: float(z["rto_h"])):
    rto, mtpd = float(z["rto_h"]), float(z["mtpd_h"])
    sch = float(z["ausfall_kosten_eur_h"]) * rto
    print("%-22s %-7s %5g %5g %5g %-6s %10.0f EUR" % (z["prozess"], z["system"], rto, mtpd, float(z["rpo_h"]), klasse(rto), sch))
    if rto >= mtpd:
        fehler += 1; print("   WARNUNG: RTO >= MTPD bei %s, Ziel unerreichbar sinnvoll" % z["prozess"])
    if float(z["kritisch_ab_h"]) > rto:
        print("   Hinweis: %s wird erst nach %g h kritisch, RTO %g h ist enger als nötig" % (z["prozess"], float(z["kritisch_ab_h"]), rto))
reihe = []
for z in sorted(zeilen, key=lambda z: float(z["rto_h"])):
    if z["system"] not in reihe: reihe.append(z["system"])   # ein System nur einmal, mit dem engsten RTO
print("\nWiederanlauf-Reihenfolge nach engstem RTO:", " > ".join(reihe))
sys.exit(1 if fehler else 0)
