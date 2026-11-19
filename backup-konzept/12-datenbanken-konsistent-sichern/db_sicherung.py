#!/usr/bin/env python3
"""Konsistente Sicherung einer laufenden Datenbank am Beispiel SQLite (Python-Standardbibliothek).
Vergleicht: (a) nacktes Kopieren der Datei während geschrieben wird, (b) sqlite3 Backup-API, (c) .dump als Text.
Aufruf: python3 db_sicherung.py [Arbeitsordner]"""
import sqlite3, sys, os, shutil, threading, time

w = sys.argv[1] if len(sys.argv) > 1 else "./lab12"
shutil.rmtree(w, ignore_errors=True); os.makedirs(w)
db = os.path.join(w, "erp.db")
c = sqlite3.connect(db, isolation_level=None)
MODUS = sys.argv[2] if len(sys.argv) > 2 else "WAL"   # WAL oder DELETE (Rollback-Journal)
c.execute("PRAGMA journal_mode=%s" % MODUS)
c.execute("CREATE TABLE konto(id INTEGER PRIMARY KEY, saldo INTEGER NOT NULL)")
c.execute("CREATE TABLE buchung(id INTEGER PRIMARY KEY, von INT, nach INT, betrag INT)")
c.executemany("INSERT INTO konto VALUES(?,?)", [(i, 1000) for i in range(1, 101)])
SUMME = 100 * 1000
stop = False

def schreiber():
    s = sqlite3.connect(db, isolation_level=None, timeout=10)
    i = 0
    while not stop:
        a, b = (i % 100) + 1, ((i * 7 + 3) % 100) + 1
        if a != b:
            s.execute("BEGIN"); s.execute("UPDATE konto SET saldo=saldo-5 WHERE id=?", (a,))
            s.execute("UPDATE konto SET saldo=saldo+5 WHERE id=?", (b,))
            s.execute("INSERT INTO buchung(von,nach,betrag) VALUES(?,?,5)", (a, b)); s.execute("COMMIT")
        i += 1

def pruefe(pfad, name):
    try:
        d = sqlite3.connect(pfad)
        ok = d.execute("PRAGMA integrity_check").fetchone()[0]
        summe = d.execute("SELECT SUM(saldo) FROM konto").fetchone()[0]
        n = d.execute("SELECT COUNT(*) FROM buchung").fetchone()[0]
        print("%-28s integrity_check=%-4s Summe der Salden=%s (Soll %d) Buchungen=%d" % (name, ok, summe, SUMME, n))
    except Exception as e:
        print("%-28s FEHLER: %s" % (name, e))

t = threading.Thread(target=schreiber); t.start(); time.sleep(0.5)
# (a) Hauptdatei langsam in Blöcken kopieren, während weiter gebucht wird (wie ein Dateikopierer bei großer Datei)
with open(db, "rb") as fi, open(os.path.join(w, "kopie_nur_db.db"), "wb") as fo:
    while True:
        blk = fi.read(4096)
        if not blk: break
        fo.write(blk); time.sleep(0.002)
# (b) Backup-API
q = sqlite3.connect(db); z = sqlite3.connect(os.path.join(w, "backup_api.db")); q.backup(z); z.close(); q.close()
# (c) Textdump
q = sqlite3.connect(db)
with open(os.path.join(w, "dump.sql"), "w") as f:
    for zeile in q.iterdump(): f.write(zeile + "\n")
q.close()
stop = True; t.join()
print("Journal-Modus: %s" % MODUS)
print("Schreiber hat parallel gebucht; es folgen die Prüfungen der drei Sicherungen.\n")
pruefe(os.path.join(w, "kopie_nur_db.db"), "(a) Datei blockweise kopiert")
pruefe(os.path.join(w, "backup_api.db"), "(b) Backup-API")
r = sqlite3.connect(os.path.join(w, "aus_dump.db")); r.executescript(open(os.path.join(w, "dump.sql")).read()); r.close()
pruefe(os.path.join(w, "aus_dump.db"), "(c) aus dump.sql wiederhergestellt")
