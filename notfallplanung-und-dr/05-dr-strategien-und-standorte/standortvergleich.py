#!/usr/bin/env python3
"""Welche DR-Variante erfüllt die Ziele zu welchen Kosten? Aufruf: python3 standortvergleich.py standorte.csv RTO_h RPO_h [Schaden_pro_h_EUR]
Es wird je Variante gerechnet: erfüllt Ziel?, Kosten pro Jahr, erwarteter Schaden pro Ereignis (Wiederanlauf x Schaden/h)."""
import csv, sys
rto, rpo = float(sys.argv[2]), float(sys.argv[3]); sch = float(sys.argv[4]) if len(sys.argv) > 4 else 0
print("Ziele: RTO %g h, RPO %g h, Schaden %g EUR/h\n" % (rto, rpo, sch))
print("%-24s %9s %8s %8s %-8s %12s %14s" % ("Variante", "EUR/Jahr", "Start h", "Verlust", "Ziel", "Betrieb", "Schaden/Fall"))
best = None
for r in csv.DictReader(open(sys.argv[1], encoding="utf-8"), delimiter=";"):
    w, d, k = float(r["wiederanlauf_h"]), float(r["datenverlust_h"]), float(r["kosten_monat_eur"]) * 12
    ok = w <= rto and d <= rpo
    print("%-24s %9.0f %8g %8g %-8s %12s %12.0f EUR" % (r["variante"], k, w, d, "erfüllt" if ok else "verfehlt", r["aufwand_betrieb"], w * sch))
    if ok and (best is None or k < best[1]): best = (r["variante"], k)
print("\nGünstigste Variante, die beide Ziele erfüllt:", "%s (%.0f EUR/Jahr)" % best if best else "keine, Ziele oder Budget überdenken")
