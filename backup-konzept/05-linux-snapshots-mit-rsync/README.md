# 05 Linux mit rsync

Übung **05.1** (Priorität 1). Geschätzte Zeit: 6 bis 8 Stunden (Schätzung; Lehrplan: 10 UE zu 45 Minuten = 7,5 Stunden).

> Skripte im Container ausgeführt; Rückgabewerte nicht gegen das Handbuch gelesen.

| Datei | Zweck |
|---|---|
| `05.1-linux-snapshots-mit-rsync.md` | Die Übung mit Aufgaben, Kontrollfragen und Musterlösung |
| `backup_linux.sh` | Versionierte Sicherung mit rsync und Hardlinks: jede Sicherung ist ein vollständiger Verzeichnisbaum, |
| `demo_snapshots.sh` | Spielt drei Sicherungstage mit backup_linux.sh durch und zeigt, dass unveränderte Dateien Hardlinks sind. |
| `beispiele/demo_snapshots.ausgabe.txt` | Echte Ausgabe des Laufs von `demo_snapshots` |
