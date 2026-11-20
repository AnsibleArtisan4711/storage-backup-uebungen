# 08 Quoten

Übung **08.1** (Priorität 1). Geschätzte Zeit: 7 bis 9 Stunden (Schätzung; Lehrplan: 12 UE zu 45 Minuten = 9 Stunden).

> Btrfs-Skripte im Container ausgeführt; ZFS als Modell.

| Datei | Zweck |
|---|---|
| `08.1-speicherverwaltung-und-quoten.md` | Die Übung mit Aufgaben, Kontrollfragen und Musterlösung |
| `erweitern_btrfs.sh` | Btrfs im laufenden Betrieb verändern: Platte hinzufügen, Balance, Profil wechseln, Platte entfernen (Loop-Geräte, erfundene Daten). |
| `lauf.sh` | Skript |
| `quoten_btrfs.sh` | Btrfs-Quoten (qgroups): Grenzen je Subvolume setzen und die Wirkung prüfen (Loop-Gerät, erfundene Daten). |
| `quoten_zfs_modell.py` | Modell (NICHT ZFS selbst): quota, refquota und reservation nach dem ZFS-Prinzip (Fachwissen, nicht bestätigt). |
| `speicher_btrfs.sh` | Btrfs: Platzbelegung richtig lesen (df, filesystem df, usage, du) und was Snapshots und Spiegel daran ändern (Loop-Geräte, erfundene Daten). |
| `beispiele/erweitern_btrfs.ausgabe.txt` | Echte Ausgabe des Laufs von `erweitern_btrfs` |
| `beispiele/lauf.ausgabe.txt` | Echte Ausgabe des Laufs von `lauf` |
| `beispiele/quoten_btrfs.ausgabe.txt` | Echte Ausgabe des Laufs von `quoten_btrfs` |
| `beispiele/speicher_btrfs.ausgabe.txt` | Echte Ausgabe des Laufs von `speicher_btrfs` |
