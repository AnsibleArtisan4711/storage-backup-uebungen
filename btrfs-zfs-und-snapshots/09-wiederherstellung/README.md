# 09 Wiederherstellung

Übung **09.1** (Priorität 1). Geschätzte Zeit: 7 bis 9 Stunden (Schätzung; Lehrplan: 12 UE zu 45 Minuten = 9 Stunden).

> Btrfs-Skripte im Container ausgeführt; ZFS als Text.

| Datei | Zweck |
|---|---|
| `09.1-wiederherstellung.md` | Die Übung mit Aufgaben, Kontrollfragen und Musterlösung |
| `ausfall_btrfs.sh` | Ausfall einer Platte im Spiegel: degradiert einbinden, Platte ersetzen, Daten prüfen (Loop-Geräte, erfundene Daten). |
| `beispiel_zfs_wiederherstellung.txt` | NICHT AUSGEFÜHRT: ZFS-Befehle zur Wiederherstellung als Beispiel (Fachwissen, nicht bestätigt; ZFS war im Test-Container nicht verfügbar). |
| `restore_btrfs.sh` | Einzelne Dateien aus einem Snapshot zurückholen (Loop-Gerät, erfundene Daten). |
| `rollback_btrfs.sh` | Ein ganzes Subvolume auf einen Snapshot zurücksetzen (Rollback) durch Austausch des Subvolumes (Loop-Gerät, erfundene Daten). |
| `beispiele/ausfall_btrfs.ausgabe.txt` | Echte Ausgabe des Laufs von `ausfall_btrfs` |
| `beispiele/restore_btrfs.ausgabe.txt` | Echte Ausgabe des Laufs von `restore_btrfs` |
| `beispiele/rollback_btrfs.ausgabe.txt` | Echte Ausgabe des Laufs von `rollback_btrfs` |
