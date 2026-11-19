# Backup-Konzept (3-2-1, RPO und RTO) (P35)

Übungsreihe zu Datensicherung: Ziele (RPO, RTO), 3-2-1-1-0, Sicherungsarten, versionierte Sicherung mit `rsync`, Windows-Sicherung mit `wbadmin` und `robocopy`, `restic`, Aufbewahrung, Verschlüsselung, unveränderliche Kopien, Restore-Tests, Datenbankkonsistenz und die Dokumentation eines Backup-Konzepts. 13 Module, 116 Unterrichtseinheiten zu 45 Minuten, davon 1 Modul mit Priorität 2 (Vertiefung). Die Aufgabentexte und Kontrollfragen stammen aus dem Lehrplan P35 (Reihe „Lehrplan-Prompts“, Datei `lehrplan_backup-konzept.md`) und sind unverändert; Hinweise, Musterlösungen und Ergänzungen sind Teil der Ausarbeitung und gekennzeichnet.

> **Prüfstand, ehrlich:** **Linux-Teile in einer Testumgebung ausgeführt, Windows nur auf Syntax geprüft, nicht unter Hyper-V.** Die Skripte der Module 2 bis 5 und 7 bis 13 wurden in einem Cloud-Container (Linux, restic 0.16.4, rsync 3.2.7, tar 1.35, gpg 2.4.4, openssl 3.0.13, Python 3.13, SQLite 3.45.1) ausgeführt; die Ausgaben stehen in den Ordnern `beispiele/` der Module. Das Windows-Skript (Modul 6) wurde mit dem PowerShell-Parser (PowerShell 7.4.6) nur auf Syntaxfehler geprüft; die Befehle von `wbadmin` und `robocopy` wurden auf Microsoft Learn gelesen (19.11.2026), aber nicht ausgeführt. **Nicht geprüft:** Hyper-V-Labor, Debian-12-Paketversionen (restic dort vermutlich älter), PostgreSQL (`pg_dump`, nur Konzept), Normen und die Regel 3-2-1 (keine geprüfte Quelle). In Modul 12 wurde der befürchtete Fehler einer Dateikopie im laufenden Betrieb **nicht reproduziert**; die Übung sagt das offen. Offene Punkte: [`befehle-nicht-bestaetigt.md`](befehle-nicht-bestaetigt.md); Anmerkungen zum Lehrplan: [`lehrplan-korrekturen.md`](lehrplan-korrekturen.md).

## Umgebung

Drei VMs unter **Hyper-V** (Lehrplan): `srv-win01` (Windows Server mit zwei zusätzlichen Platten), `srv-lin01` und `bkp01` (Debian 12) am privaten Switch `Lab-Internal-Net` (`192.168.10.0/24`, statisch, kein DHCP, kein DNS). Die Pakete werden vor Kursbeginn einmalig mit Internetzugang installiert (Details im Lehrplan). Das Labor wurde **nicht** aufgebaut; die Linux-Skripte laufen auf jeder Debian- oder Ubuntu-Maschine mit den genannten Werkzeugen.

## Module

| Nr. | Modul | Zeit | Prüfstand |
|---|---|---|---|
| 01 | [Grundlagen: Warum Backup, Schutzziele und Ursachen für Datenverlust](01-grundlagen-und-schutzziele/) | 4,5 h | Entwurf, keine Befehle; Fachwissen ohne geprüfte Quelle. |
| 02 | [RPO und RTO: Ziele festlegen und prüfen](02-rpo-und-rto/) | 6,75 h | Skript im Container ausgeführt; Rechenmodell der Übung, keine Messung. |
| 03 | [Die 3-2-1-Regel und 3-2-1-1-0](03-drei-zwei-eins-regel/) | 6 h | Skript im Container ausgeführt; Zählweise der Regel ist eine Auslegung. |
| 04 | [Sicherungsarten: voll, inkrementell, differenziell](04-sicherungsarten/) | 6,75 h | Skripte im Container ausgeführt; Modellwerte. |
| 05 | [Linux: versionierte Sicherung mit rsync und Hardlinks](05-linux-snapshots-mit-rsync/) | 7,5 h | Skripte im Container ausgeführt; Rückgabewerte nicht gegen das Handbuch gelesen. |
| 06 | [Windows: Sicherung mit wbadmin und robocopy](06-windows-mit-wbadmin-und-robocopy/) | 7,5 h | Befehle auf Microsoft Learn gelesen; Skript nur auf Syntax geprüft; nicht auf Windows ausgeführt. |
| 07 | [restic: verschlüsselte, deduplizierende Sicherung](07-restic-sicherung/) | 7,5 h | Skript im Container ausgeführt; versionsabhängige Ausgaben. |
| 08 | [Aufbewahrung: Großvater-Vater-Sohn und Löschregeln](08-aufbewahrung-gfs/) | 6 h | Skripte im Container ausgeführt; Fristen sind keine Rechtsberatung. |
| 09 | [Verschlüsselung von Sicherungen und Schlüsselverwaltung](09-verschluesselung-der-sicherung/) | 6 h | Skript im Container ausgeführt; Aussage zu CBC nicht gemessen. |
| 10 | [Unveränderbare Kopien und Schutz vor Ransomware](10-unveraenderbarkeit-und-ransomware/) | 6,75 h | Skript im Container ausgeführt; Laborsimulation, Grenzen sind Fachwissen. |
| 11 | [Restore-Tests, Prüfsummen und Fehlersuche](11-restore-tests-und-integritaet/) | 7,5 h | Skript im Container ausgeführt; Rückgabewerte nur beobachtet. |
| 12 | [Datenbanken konsistent sichern (SQLite als Beispiel)](12-datenbanken-konsistent-sichern/) (Priorität 2) | 4,5 h | Skript im Container ausgeführt; Fehlerfall nicht reproduziert; PostgreSQL nicht ausgeführt. |
| 13 | [Backup-Konzept dokumentieren, überwachen und berichten](13-konzept-und-berichte/) | 9,75 h | Skript im Container ausgeführt; Konzept ist Schreibaufgabe. |

Summe 87 Stunden.

## Aufbau eines Moduls

Ordner `NN-kurzname/` mit `README.md`, der Übung `NN.1-….md` (Lernziele, Voraussetzungen, Grundbegriffe, Aufgaben, Hinweise, Kontrollfragen, einklappbare Musterlösung, Erweiterungen, Quellen), den Skripten und Beispieldaten des Moduls und einem Ordner `beispiele/` mit den echten Ausgaben der Läufe. Die Skripte schreiben nur in einen Arbeitsordner (Parameter oder Standard `./labNN`) und räumen ihn zu Beginn auf.

## Hinweise

- Nur im Labor ausführen. Kennwörter und Schlüssel in den Beispielen sind Laborwerte; echte Kennwörter gehören nie in ein Repository.
- `ransomware_sim.sh` (Modul 10) überschreibt Dateien nur im Arbeitsordner und bricht ab, wenn dieser nicht unter `/tmp` oder `/home` liegt; trotzdem nie auf echten Daten ausführen. Vor dem Löschen des Ordners `chattr -R -i` ausführen.
- Beim Löschen von Sicherungen (`forget --prune`, `robocopy /MIR`) vorher immer den Trockenlauf prüfen.
- Alle Namen, Firmen, Zahlen und Adressen sind frei erfunden (`example.internal`, Adressen nach RFC 1918).
- Aussagen zu Normen und Fristen sind Fachwissen und keine Rechtsberatung.

## Lizenz

- Skripte: MIT, siehe [`LICENSE`](LICENSE)
- Texte: CC BY 4.0, siehe [`LICENSE-DOCS.md`](LICENSE-DOCS.md)

*Lizenz: Text CC BY 4.0, Skripte MIT, siehe `LICENSE-DOCS.md` und `LICENSE` im Kursordner. Alle Personen, Firmen, Zahlen und Termine sind frei erfunden. Windows und Windows Server sind Marken der Microsoft Corporation; dieses Dokument steht in keiner Verbindung zu Microsoft.*
