# 08 Überwachung

Übung **08.1** (Priorität 1). Geschätzte Zeit: 7 bis 9 Stunden (Schätzung; Lehrplan: 12 UE zu 45 Minuten = 9 Stunden).

> Skripte im Container ausgeführt; RAID und Snapshots nicht ausgeführt.

| Datei | Zweck |
|---|---|
| `08.1-ueberwachung-des-speicherplatzes.md` | Die Übung mit Aufgaben, Kontrollfragen und Musterlösung |
| `beispiel_mdadm_snapshot.txt` | Software-RAID und LVM-Snapshots (NICHT AUSGEFÜHRT: im Test-Container fehlen md und Device-Mapper; aus Fachwissen, nicht bestätigt) |
| `lauf.sh` | Skript |
| `platz.sh` | Speicherplatz überwachen: df, Inodes, "No space left" trotz freiem Platz (Loop-Gerät, erfundene Daten). |
| `schwelle.py` | Prüft Belegungswerte gegen Schwellen (Modell, erfundene Werte). Ausgabe wie ein einfaches Überwachungsskript. |
| `beispiele/lauf.ausgabe.txt` | Echte Ausgabe des Laufs von `lauf` |
| `beispiele/platz.ausgabe.txt` | Echte Ausgabe des Laufs von `platz` |
