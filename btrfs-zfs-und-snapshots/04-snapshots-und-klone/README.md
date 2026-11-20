# 04 Snapshots

Übung **04.1** (Priorität 1). Geschätzte Zeit: 7 bis 9 Stunden (Schätzung; Lehrplan: 12 UE zu 45 Minuten = 9 Stunden).

> Btrfs-Skripte im Container ausgeführt; ZFS als Modell.

| Datei | Zweck |
|---|---|
| `04.1-snapshots-und-klone.md` | Die Übung mit Aufgaben, Kontrollfragen und Musterlösung |
| `lauf.sh` | Skript |
| `rotation.py` | Welche Snapshots werden behalten? Aufbewahrungsregel: letzte N tägliche, M wöchentliche (Sonntag), K monatliche (1. des Monats). |
| `snapshots_btrfs.sh` | Btrfs-Snapshots: schreibgeschützt und beschreibbar, Platzbedarf, Zugriff auf alte Stände (Loop-Gerät, erfundene Daten). |
| `zfs_snapshots_modell.py` | Modell (NICHT ZFS selbst): Snapshots, Klone und Platzabrechnung nach dem ZFS-Prinzip (Fachwissen, nicht bestätigt). |
| `beispiele/lauf.ausgabe.txt` | Echte Ausgabe des Laufs von `lauf` |
| `beispiele/snapshots_btrfs.ausgabe.txt` | Echte Ausgabe des Laufs von `snapshots_btrfs` |
