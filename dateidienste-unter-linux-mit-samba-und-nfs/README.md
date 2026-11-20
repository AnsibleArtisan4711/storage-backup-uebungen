# Dateidienste unter Linux mit Samba und NFS (P55)

Übungsreihe zu Dateidiensten unter Linux: SMB und NFS im Überblick, Samba als Standalone-Server, Freigaben und Berechtigungen, ACLs, Samba als Domänenmitglied (Grundzüge), NFS-Exporte und Mount-Optionen, Sicherheit, Fehlersuche und Sicherung. 8 Module, 98 Unterrichtseinheiten zu 45 Minuten, davon 1 Modul mit Priorität 2 (Vertiefung). Praxisübungen mit Samba über Loopback; NFS und Domänenbeitritt als Modell und Text. Die Aufgabentexte und Kontrollfragen stammen aus dem Lehrplan P55 (Reihe „Lehrplan-Prompts“, Datei `P55-dateidienste-unter-linux-mit-samba-und-nfs.md`) und sind unverändert; Hinweise, Musterlösungen und Ergänzungen sind Teil der Ausarbeitung und gekennzeichnet.

> **Prüfstand, ehrlich:** **Im Cloud-Container ausgeführt, nicht in Hyper-V.** Die Samba-Skripte liefen mit Samba 4.19.5 (Ubuntu 24.04, Kernel 6.18.44) über Loopback; die Ausgaben stehen in den Ordnern `beispiele/`. Alle Daten sind erfunden. **NFS, Windows-Clients und der Domänenbeitritt wurden nicht ausgeführt**: Diese Teile sind Modelle und Textdateien aus Fachwissen und nicht bestätigt. Bestätigt wurde das Verhalten der Programme in diesem Lauf, **nicht** gegen die Dokumentation. Offene Punkte: [`befehle-nicht-bestaetigt.md`](befehle-nicht-bestaetigt.md); Anmerkungen zum Lehrplan: [`lehrplan-korrekturen.md`](lehrplan-korrekturen.md).

## Umgebung

Linux-VMs und ein Windows-11-Client unter **Hyper-V** (Lehrplan): `fs01` (`10.55.0.2`, Debian/Ubuntu Server), `win11` und `lx01` am privaten Switch `Lab-Dateidienste` (`10.55.0.0/24`). Das Labor wurde **nicht** aufgebaut. Die Skripte starten stattdessen einen Samba-Server auf `127.0.0.1:4455` mit Daten unter `/tmp/p55` und brauchen `root`.

## Module

| Nr. | Modul | Zeit | Prüfstand |
|---|---|---|---|
| 01 | [SMB und NFS im Überblick](01-smb-und-nfs-im-ueberblick/) | 9 h | Tabelle ausgeführt; NFS nicht ausgeführt. |
| 02 | [Samba als Standalone-Server](02-samba-als-standalone-server/) | 10,5 h | Skript im Container ausgeführt; Windows-Zugriff nicht ausgeführt. |
| 03 | [Freigaben und Berechtigungen](03-freigaben-und-berechtigungen/) | 10,5 h | Skript im Container ausgeführt. |
| 04 | [ACLs für Freigaben](04-acls-fuer-freigaben/) | 9 h | Skript im Container ausgeführt. |
| 05 | [Samba als Domänenmitglied (Grundzüge)](05-samba-als-domaenenmitglied/) (Priorität 2) | 7,5 h | Syntax mit `testparm` geprüft; Beitritt nicht ausgeführt. |
| 06 | [NFS-Exporte und Mount-Optionen](06-nfs-exporte-und-mount-optionen/) | 9 h | Nur Modell und Text; NFS nicht ausgeführt. |
| 07 | [Sicherheit bei Dateidiensten](07-sicherheit-bei-dateidiensten/) | 9 h | Skript im Container ausgeführt; Windows-Clients nicht geprüft. |
| 08 | [Fehlersuche und Sicherung](08-fehlersuche-und-sicherung/) | 9 h | Skript im Container ausgeführt. |

Summe 73,5 Stunden.

## Aufbau eines Moduls

Ordner `NN-kurzname/` mit `README.md`, der Übung `NN.1-….md` (Lernziele, Voraussetzungen, Grundbegriffe, Aufgaben, Hinweise, Kontrollfragen, einklappbare Musterlösung, Erweiterungen, Quellen), den Skripten und Beispieldaten des Moduls und einem Ordner `beispiele/` mit den echten Ausgaben der Läufe. Die Skripte der Module liegen im jeweiligen Modulordner und binden `../lab.sh` ein.

## Hinweise

- Die Skripte legen die Benutzer `anna` und `ben` und die Gruppe `projekt` an, starten einen Samba-Server und entfernen alles am Ende (`lab_down`). **Nicht auf einem Rechner mit wichtigen Daten oder laufendem Samba ausführen.**
- Das Passwort `Geheim-123` ist ein erfundenes Beispiel; in der Praxis nie ein Passwort im Skript verwenden.
- Alle Namen, Adressen (`10.55.0.0/24`) und Daten sind erfunden.
- Befehle in `beitritt.txt` und `beispiel_nfs.txt` und das Modell in `exports_pruefen.py` wurden nicht ausgeführt bzw. nicht gegen die Dokumentation geprüft.

## Lizenz

- Skripte: MIT, siehe [`LICENSE`](LICENSE)
- Texte: CC BY 4.0, siehe [`LICENSE-DOCS.md`](LICENSE-DOCS.md)

*Lizenz: Text CC BY 4.0, Skripte MIT, siehe `LICENSE-DOCS.md` und `LICENSE` im Kursordner. Alle Personen, Firmen, Zahlen und Termine sind frei erfunden. Windows und Windows Server sind Marken der Microsoft Corporation; dieses Dokument steht in keiner Verbindung zu Microsoft.*
