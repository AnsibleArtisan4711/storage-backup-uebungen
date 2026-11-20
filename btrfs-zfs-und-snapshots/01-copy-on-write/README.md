# 01 Copy-on-Write

Übung **01.1** (Priorität 1). Geschätzte Zeit: 6 bis 8 Stunden (Schätzung; Lehrplan: 10 UE zu 45 Minuten = 7,5 Stunden).

> Skripte im Container ausgeführt.

| Datei | Zweck |
|---|---|
| `01.1-copy-on-write.md` | Die Übung mit Aufgaben, Kontrollfragen und Musterlösung |
| `cow_btrfs.sh` | Copy-on-Write in Btrfs: Reflink-Kopie teilt Blöcke mit dem Original, bis eine Seite geändert wird (Loop-Gerät, erfundene Daten). |
| `cow_modell.py` | Modell: Überschreiben an Ort und Stelle gegen Copy-on-Write (CoW). |
| `lauf.sh` | Skript |
| `beispiele/cow_btrfs.ausgabe.txt` | Echte Ausgabe des Laufs von `cow_btrfs` |
| `beispiele/lauf.ausgabe.txt` | Echte Ausgabe des Laufs von `lauf` |
