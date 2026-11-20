"""Prüft eine fstab-Zeile auf typische Fehler (Modell, erfundene Zeilen)."""
Z = ["UUID=1234 /daten ext4 defaults 0 2", "/dev/sdb1 /backup ext4 defaults 0 2", "UUID=5678 /srv xfs defaults 0 1",
     "UUID=9abc /tmp tmpfs defaults", "UUID=def0 /home ext4 defaults,noexec 0 2"]
for z in Z:
    f = z.split(); w = []
    if len(f) != 6: w.append("%d statt 6 Felder" % len(f))
    if f[0].startswith("/dev/sd"): w.append("Gerätename kann sich ändern: UUID verwenden")
    if len(f) == 6 and f[2] == "xfs" and f[5] != "0": w.append("fsck-Reihenfolge bei XFS ohne Wirkung (0 üblich)")
    if len(f) == 6 and f[1] == "/home" and "noexec" in f[3]: w.append("noexec auf /home kann Programme der Benutzer blockieren")
    print("%-45s %s" % (z, "; ".join(w) or "ok"))
