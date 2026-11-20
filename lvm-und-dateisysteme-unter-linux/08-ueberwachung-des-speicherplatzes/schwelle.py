"""Prüft Belegungswerte gegen Schwellen (Modell, erfundene Werte). Ausgabe wie ein einfaches Überwachungsskript."""
W, K = 80, 90
mounts = [("/", 62, 40), ("/var", 83, 12), ("/daten", 91, 95), ("/backup", 45, 97)]
rc = 0
for pfad, platz, inode in mounts:
    for art, wert in (("Platz", platz), ("Inodes", inode)):
        s = "KRITISCH" if wert >= K else "WARNUNG" if wert >= W else "ok"
        if s != "ok": rc = max(rc, 2 if s == "KRITISCH" else 1)
        print("%-8s %-7s %3d %%  %s" % (pfad, art, wert, s))
print("Exitcode:", rc)
