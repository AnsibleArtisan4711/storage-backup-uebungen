# 07 Kompression

Übung **07.1** (Priorität 2, Vertiefung, kann bei Zeitmangel entfallen). Geschätzte Zeit: 5 bis 6 Stunden (Schätzung; Lehrplan: 8 UE zu 45 Minuten = 6 Stunden).

> Btrfs-Skripte im Container ausgeführt; ZFS nicht ausgeführt.

| Datei | Zweck |
|---|---|
| `07.1-kompression.md` | Die Übung mit Aufgaben, Kontrollfragen und Musterlösung |
| `kompression_btrfs.sh` | Btrfs-Kompression: Wirkung auf gut und schlecht komprimierbare Daten messen (Loop-Gerät, erfundene Daten). |
| `kompression_modell.py` | Wann lohnt sich Kompression? Misst mit zlib (Python-Standardbibliothek) und erfundenen Testdaten (fester Startwert). |
| `lauf.sh` | Skript |
| `beispiele/kompression_btrfs.ausgabe.txt` | Echte Ausgabe des Laufs von `kompression_btrfs` |
| `beispiele/lauf.ausgabe.txt` | Echte Ausgabe des Laufs von `lauf` |
