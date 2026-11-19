#!/usr/bin/env python3
"""Auswertung einer Notfallübung: Soll/Ist je Schritt, Abweichungen, nicht durchgeführte Schritte, Maßnahmenvorschläge.
Aufruf: python3 uebung_protokoll.py uebung.csv [Toleranz_Prozent, Standard 20]   Zeiten in Minuten seit Übungsbeginn."""
import csv, sys
tol = float(sys.argv[2]) if len(sys.argv) > 2 else 20
z = list(csv.DictReader(open(sys.argv[1], encoding="utf-8"), delimiter=";"))
print("%-3s %-42s %5s %5s %7s  %s" % ("Nr", "Schritt", "Soll", "Ist", "Abw.", "Bewertung"))
offen = []
for r in z:
    s = float(r["soll_min"])
    if not r["ist_min"]:
        print("%-3s %-42s %5g %5s %7s  NICHT DURCHGEFÜHRT" % (r["schritt"], r["beschreibung"][:42], s, "-", "-")); offen.append((r["schritt"], "nicht durchgeführt")); continue
    i = float(r["ist_min"]); a = (i - s) / s * 100
    bew = "ok" if a <= tol else "ZU LANGSAM"
    print("%-3s %-42s %5g %5g %6.0f%%  %s" % (r["schritt"], r["beschreibung"][:42], s, i, a, bew))
    if bew != "ok": offen.append((r["schritt"], r["bemerkung"] or "Ursache klären"))
print("\nMaßnahmenvorschläge aus der Übung (Quelle für Modul 11):")
for n, t in offen: print("  Schritt %s: %s" % (n, t))
print("\n%d von %d Schritten auffällig." % (len(offen), len(z)))
