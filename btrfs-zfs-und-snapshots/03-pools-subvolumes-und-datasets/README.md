# 03 Aufbau

Übung **03.1** (Priorität 1). Geschätzte Zeit: 7 bis 9 Stunden (Schätzung; Lehrplan: 12 UE zu 45 Minuten = 9 Stunden).

> Btrfs-Skripte im Container ausgeführt; ZFS als Modell.

| Datei | Zweck |
|---|---|
| `03.1-pools-subvolumes-und-datasets.md` | Die Übung mit Aufgaben, Kontrollfragen und Musterlösung |
| `beispiel_zfs.txt` | NICHT AUSGEFÜHRT: ZFS-Befehle als Beispiel (Fachwissen, nicht bestätigt; ZFS war im Test-Container nicht verfügbar). |
| `btrfs_pool.sh` | Btrfs: ein Dateisystem über mehrere Platten (raid1), Subvolumes anlegen und gezielt einbinden (Loop-Geräte, erfundene Daten). |
| `lauf.sh` | Skript |
| `zfs_modell.py` | Modell (NICHT ZFS selbst): Pool, vdevs, Datasets und vererbte Eigenschaften nach dem ZFS-Aufbau (Fachwissen, nicht bestätigt). |
| `beispiele/btrfs_pool.ausgabe.txt` | Echte Ausgabe des Laufs von `btrfs_pool` |
| `beispiele/lauf.ausgabe.txt` | Echte Ausgabe des Laufs von `lauf` |
