# 05 Replikation

Übung **05.1** (Priorität 1). Geschätzte Zeit: 7 bis 9 Stunden (Schätzung; Lehrplan: 12 UE zu 45 Minuten = 9 Stunden).

> Btrfs-Skripte im Container ausgeführt; ZFS als Text.

| Datei | Zweck |
|---|---|
| `05.1-replikation-mit-send-und-receive.md` | Die Übung mit Aufgaben, Kontrollfragen und Musterlösung |
| `lauf.sh` | Skript |
| `replikationsplan.py` | Hilfsmodell: Welcher Snapshot dient als gemeinsame Basis für eine inkrementelle Übertragung? |
| `send_receive_btrfs.sh` | Btrfs send/receive: Snapshots auf ein zweites Dateisystem übertragen, zuerst vollständig, dann inkrementell (Loop-Geräte, erfundene Daten). |
| `beispiele/lauf.ausgabe.txt` | Echte Ausgabe des Laufs von `lauf` |
| `beispiele/send_receive_btrfs.ausgabe.txt` | Echte Ausgabe des Laufs von `send_receive_btrfs` |
