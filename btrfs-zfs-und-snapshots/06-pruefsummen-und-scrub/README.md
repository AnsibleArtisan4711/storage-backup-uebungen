# 06 Scrub

Übung **06.1** (Priorität 1). Geschätzte Zeit: 6 bis 8 Stunden (Schätzung; Lehrplan: 10 UE zu 45 Minuten = 7,5 Stunden).

> Btrfs-Skripte im Container ausgeführt.

| Datei | Zweck |
|---|---|
| `06.1-pruefsummen-und-scrub.md` | Die Übung mit Aufgaben, Kontrollfragen und Musterlösung |
| `lauf.sh` | Skript |
| `pruefsumme_modell.py` | Modell: Warum Prüfsummen schleichende Datenfehler („Bit-Rot“) erkennen und mit einer zweiten Kopie reparieren können. |
| `scrub_btrfs.sh` | Btrfs-Scrub: Beschädigung einer Platte erkennen und aus dem Spiegel reparieren (raid1); ohne Spiegel (single) nur erkennen (Loop-Geräte, erfundene Daten). |
| `beispiele/lauf.ausgabe.txt` | Echte Ausgabe des Laufs von `lauf` |
| `beispiele/scrub_btrfs.ausgabe.txt` | Echte Ausgabe des Laufs von `scrub_btrfs` |
