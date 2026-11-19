#!/usr/bin/env python3
"""Maßnahmenverfolgung nach Übung/Vorfall: überfällige, offene, erledigte Punkte.
Aufruf: python3 massnahmen.py massnahmen.csv [Stichtag YYYY-MM-DD]"""
import csv, sys, datetime as dt
heute = dt.datetime.strptime(sys.argv[2], "%Y-%m-%d").date() if len(sys.argv) > 2 else dt.date.today()
z = list(csv.DictReader(open(sys.argv[1], encoding="utf-8"), delimiter=";"))
print("Stichtag %s\n" % heute)
print("%-3s %-52s %-10s %-10s %-9s %s" % ("ID", "Maßnahme", "fällig", "Status", "Priorität", "Bewertung"))
ueber = 0
for r in sorted(z, key=lambda r: r["faellig"]):
    f = dt.datetime.strptime(r["faellig"], "%Y-%m-%d").date()
    if r["status"] == "erledigt": bew = "erledigt"
    elif f < heute: bew = "ÜBERFÄLLIG seit %d Tagen" % (heute - f).days; ueber += 1
    else: bew = "in %d Tagen fällig" % (f - heute).days
    print("%-3s %-52s %-10s %-10s %-9s %s" % (r["id"], r["massnahme"][:52], r["faellig"], r["status"], r["prioritaet"], bew))
st = {}
for r in z: st[r["status"]] = st.get(r["status"], 0) + 1
print("\nStatus:", ", ".join("%s %d" % (k, v) for k, v in sorted(st.items())), "| überfällig:", ueber)
sys.exit(1 if ueber else 0)
