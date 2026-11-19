#!/usr/bin/env python3
"""Notfallhandbuch auf Vollständigkeit und Aktualität prüfen (Markdown-Datei).
Aufruf: python3 handbuch_pruefen.py handbuch.md [Stichtag YYYY-MM-DD]
Prüft: Pflichtabschnitte, Stand nicht älter als 12 Monate, Verweise ins Leere ('siehe Aushang'), Schritte ohne Prüfkriterium."""
import re, sys, datetime as dt
text = open(sys.argv[1], encoding="utf-8").read()
heute = dt.datetime.strptime(sys.argv[2], "%Y-%m-%d").date() if len(sys.argv) > 2 else dt.date.today()
PFLICHT = ["Zweck", "Alarmierung", "Rollen", "Wiederanlauf", "Wiederherstellung", "Kontakte", "Kommunikation", "Datenschutz", "Übung"]
befunde = []
for p in PFLICHT:
    if not re.search(r"^## \d+\. .*%s" % p, text, re.M): befunde.append("Abschnitt fehlt: %s" % p)
m = re.search(r"Stand:\s*(\d{4}-\d{2}-\d{2})", text)
if not m: befunde.append("Kein Stand angegeben")
else:
    alter = (heute - dt.datetime.strptime(m.group(1), "%Y-%m-%d").date()).days
    if alter > 365: befunde.append("Stand ist %d Tage alt (mehr als 12 Monate)" % alter)
if re.search(r"[Ss]iehe Aushang|[Ss]iehe Intranet", text): befunde.append("Verweis auf Aushang/Intranet: im Notfall evtl. nicht erreichbar, Kopie offline beilegen")
if not re.search(r"Telefon|\+\d{2}", text): befunde.append("Keine Telefonnummern im Dokument")
abschn = re.search(r"## \d+\. Wiederherstellung.*?(?=\n## |\Z)", text, re.S)
if abschn:
    schritte = re.findall(r"^\d+\. (.+)$", abschn.group(0), re.M)
    for s in schritte:
        if not re.search(r"prüf|kontroll|Ergebnis|erwartet", s, re.I): befunde.append("Schritt ohne Prüfkriterium: '%s'" % s)
print("Prüfung von %s (Stichtag %s)" % (sys.argv[1], heute))
for b in befunde: print(" -", b)
print("%d Befund(e)." % len(befunde)); sys.exit(1 if befunde else 0)
