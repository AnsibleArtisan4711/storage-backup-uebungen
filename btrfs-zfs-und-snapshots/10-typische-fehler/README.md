# 10 Fehler

Übung **10.1** (Priorität 1). Geschätzte Zeit: 6 bis 8 Stunden (Schätzung; Lehrplan: 10 UE zu 45 Minuten = 7,5 Stunden).

> Btrfs-Skripte im Container ausgeführt.

| Datei | Zweck |
|---|---|
| `10.1-typische-fehler.md` | Die Übung mit Aufgaben, Kontrollfragen und Musterlösung |
| `beispiel_meldungen.txt` | Meldungen aus den Läufen dieser Übungsreihe (Auszüge, Pfade und IDs gekürzt) und eine erfundene Zeile zum Üben |
| `diagnose.py` | Ordnet Fehlermeldungen (Textzeilen) möglichen Ursachen und nächsten Schritten zu. |
| `fehler_platz.sh` | Typischer Fehler: „No space left on device“, obwohl Dateien gelöscht wurden (Snapshot hält die Blöcke) (Loop-Gerät, erfundene Daten). |
| `fehler_send.sh` | Typische Fehler bei send/receive: nicht schreibgeschützt, Elternsnapshot fehlt, Name existiert schon (Loop-Geräte, erfundene Daten). |
| `lauf.sh` | Skript |
| `beispiele/fehler_platz.ausgabe.txt` | Echte Ausgabe des Laufs von `fehler_platz` |
| `beispiele/fehler_send.ausgabe.txt` | Echte Ausgabe des Laufs von `fehler_send` |
| `beispiele/lauf.ausgabe.txt` | Echte Ausgabe des Laufs von `lauf` |
