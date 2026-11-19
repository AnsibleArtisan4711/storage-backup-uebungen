# Anmerkungen zum Lehrplan P35

Beim Ausarbeiten und Testen aufgefallene Punkte. Der Lehrplan selbst wurde zusammen mit der Übungsreihe erstellt und danach **nicht** verändert.

| Nr. | Modul | Befund | Vorschlag |
|---|---|---|---|
| 1 | 04 | **Aufgabe 4 (Kettenbruch):** Beim Zurückspielen von Voll plus zweitem Inkrement unter Auslassung des ersten Inkrements meldet tar keinen Fehler, die in Inkrement 1 gesicherte neue Datei fehlt aber. Wer nur auf Fehlermeldungen achtet, bemerkt den Bruch nicht. | Im Lehrplan als Hinweis ergänzen: Kette lückenlos aufbewahren und beim Test auf Vollständigkeit prüfen. |
| 2 | 05 | **Aufgabe 2:** Ohne Pause zwischen den Läufen erkennt rsync Änderungen in derselben Sekunde mit gleicher Größe nicht (Quick-Check). Die Demo fügt `sleep 2` ein. | Hinweis „Quick-Check und `--checksum`“ in die Lerneinheit 5.1 aufnehmen. |
| 3 | 06 | **Windows-Teile:** nicht ausgeführt; Windows-Feature-Name für Windows Server Backup und Ausgabetexte der deutschen Oberfläche nicht bestätigt. | In der VM prüfen und Ergebnisse ergänzen. |
| 4 | 09 | **Aufgabe 4:** `restic key remove` verweigert das Entfernen des aktuell verwendeten Schlüssels; der Lehrplan muss die Reihenfolge (erst mit dem anderen Schlüssel anmelden) nennen. | Hinweis in die Aufgabe aufnehmen. |
| 5 | 11 | **Aufgabe 2:** `restic check` ohne `--read-data` meldet bei einem beschädigten Datenpaket Rückgabewert 0; erst `--read-data` findet den Fehler. Je nach getroffenem Paket erscheinen unterschiedliche Meldungen. | Hinweis ergänzen, damit „check ok“ nicht als „Daten ok“ gelesen wird. |
| 6 | 12 | **Aufgabe 1:** Der befürchtete Fehler einer Dateikopie im laufenden Betrieb ließ sich im Labor nicht reproduzieren (kleine Datenbank). Die Übung kann deshalb den Unterschied zwischen den Verfahren nicht zeigen, nur dass alle drei fehlerfrei waren. | Aufgabe um eine größere Datenbank oder einen erzwungenen Abbruch während des Kopierens erweitern. |
| 7 | 13 | **Aufgabe 3:** Grenzwerte im Berichtsskript (26 Stunden, 90 Tage) sind Annahmen der Übung. | Im Konzept bewusst festlegen und begründen lassen. |
