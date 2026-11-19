#!/usr/bin/env python3
"""Backup-Statusbericht: prüft Läufe gegen Regeln (Alter, Status, Restore-Test) und liefert Rückgabewert 0/1 für Monitoring.
Aufruf: python3 bericht.py laeufe.csv [Stichtag YYYY-MM-DD HH:MM]
Regeln (anpassbar oben): max. Alter 26 h, Restore-Test höchstens 90 Tage alt, Status muss OK sein."""
import csv, sys, datetime as dt

MAX_ALTER_H, MAX_TEST_TAGE = 26, 90
jetzt = dt.datetime.strptime(sys.argv[2], "%Y-%m-%d %H:%M") if len(sys.argv) > 2 else dt.datetime.now()
probleme = 0
print("Backup-Bericht, Stichtag %s" % jetzt.strftime("%Y-%m-%d %H:%M"))
print("%-15s %-8s %-9s %s" % ("Job", "System", "Ergebnis", "Befund"))
for z in csv.DictReader(open(sys.argv[1], encoding="utf-8"), delimiter=";"):
    b = []
    alter = (jetzt - dt.datetime.strptime(z["letzter_lauf"], "%Y-%m-%d %H:%M")).total_seconds() / 3600
    if z["status"] != "OK": b.append("Lauf fehlgeschlagen")
    if alter > MAX_ALTER_H: b.append("letzter Lauf %.0f h her (max. %d)" % (alter, MAX_ALTER_H))
    t = z["letzter_restore_test"]
    if not t: b.append("noch nie ein Restore-Test")
    else:
        tage = (jetzt.date() - dt.datetime.strptime(t, "%Y-%m-%d").date()).days
        if tage > MAX_TEST_TAGE: b.append("Restore-Test %d Tage alt (max. %d)" % (tage, MAX_TEST_TAGE))
    probleme += bool(b)
    print("%-15s %-8s %-9s %s" % (z["job"], z["system"], "OK" if not b else "PRÜFEN", "; ".join(b)))
print("\n%d Jobs mit Befund." % probleme)
sys.exit(1 if probleme else 0)
