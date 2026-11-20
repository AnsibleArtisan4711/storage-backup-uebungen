"""Vergleich ext4 und XFS als Tabelle. Spalte 'Status': L = in diesem Kurs im Container geprüft, F = Fachwissen, nicht bestätigt."""
Z = [("Journal", "ja (Metadaten, optional Daten)", "ja (Metadaten)", "F"),
     ("Vergrößern im laufenden Betrieb", "ja (resize2fs)", "ja (xfs_growfs)", "L"),
     ("Verkleinern", "ja, nur ausgehängt (resize2fs)", "nein (im Lauf abgelehnt)", "L"),
     ("Inodes", "beim Anlegen festgelegt", "dynamisch", "L"),
     ("Dateisystemprüfung", "e2fsck (ausgehängt)", "xfs_repair (ausgehängt)", "L"),
     ("Quotas", "Benutzer, Gruppe, Projekt", "Benutzer, Gruppe, Projekt", "L"),
     ("Typischer Einsatz", "Allzweck, kleine bis mittlere Systeme", "große Dateien, viele parallele Zugriffe", "F"),
     ("Maximale Größe", "nach Dokumentation prüfen", "nach Dokumentation prüfen", "F")]
print("%-32s %-36s %-40s %s" % ("Merkmal", "ext4", "XFS", "Status"))
for z in Z: print("%-32s %-36s %-40s %s" % z)
print("\nL geprüft: %d, F nicht bestätigt: %d" % (sum(z[3] == "L" for z in Z), sum(z[3] == "F" for z in Z)))
