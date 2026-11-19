#!/usr/bin/env python3
"""Gesamtprüfung eines DR-Plans: Konsistenz zwischen BIA (prozesse.csv), Abhängigkeiten, Kontakten und Maßnahmen.
Aufruf: python3 dr_gesamtcheck.py [Stichtag YYYY-MM-DD]   (Dateien im selben Ordner)"""
import csv, sys, datetime as dt
heute = dt.datetime.strptime(sys.argv[1], "%Y-%m-%d").date() if len(sys.argv) > 1 else dt.date.today()
rd = lambda f: list(csv.DictReader(open(f, encoding="utf-8"), delimiter=";"))
pro, abh, kon, mas = rd("prozesse.csv"), rd("abhaengigkeiten.csv"), rd("kontakte.csv"), rd("massnahmen.csv")
b = []
systeme = {a["system"]: a for a in abh}
for p in pro:
    if p["system"] not in systeme: b.append("System %s aus der BIA fehlt in den Abhängigkeiten" % p["system"])
    elif float(systeme[p["system"]]["rto_h"]) != float(p["rto_h"]):
        b.append("RTO von %s weicht ab: BIA %s h, Abhängigkeiten %s h" % (p["system"], p["rto_h"], systeme[p["system"]]["rto_h"]))
for k in kon:
    if not k["vertretung"]: b.append("Rolle '%s' ohne Vertretung" % k["rolle"])
for m in mas:
    if m["status"] != "erledigt" and dt.datetime.strptime(m["faellig"], "%Y-%m-%d").date() < heute: b.append("Maßnahme %s überfällig" % m["id"])
print("DR-Gesamtprüfung, Stichtag %s" % heute)
b = list(dict.fromkeys(b))   # doppelte Befunde entfernen
for x in b: print(" -", x)
print("%d Befund(e)." % len(b)); sys.exit(1 if b else 0)
