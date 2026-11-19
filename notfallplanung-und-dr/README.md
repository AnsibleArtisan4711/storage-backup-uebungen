# Notfallplanung und Disaster Recovery (P36)

Übungsreihe zur Notfallplanung und Disaster Recovery: Business-Impact-Analyse, Risikoanalyse, Wiederanlauf-Reihenfolge, DR-Strategien und Standorte, Alarmierung, Wiederherstellung unter Linux (mit Zeitmessung) und Windows/Active Directory, Notfallhandbuch, Notfallübung, Maßnahmenverfolgung, Szenario Cyberangriff und ein Abschlussprojekt. 13 Module, 111 Unterrichtseinheiten zu 45 Minuten, davon 2 Module mit Priorität 2 (Vertiefung). Die Aufgabentexte und Kontrollfragen stammen aus dem Lehrplan P36 (Reihe „Lehrplan-Prompts“, Datei `lehrplan_notfallplanung-und-dr.md`) und sind unverändert; Hinweise, Musterlösungen und Ergänzungen sind Teil der Ausarbeitung und gekennzeichnet.

> **Prüfstand, ehrlich:** **Planungsskripte in einer Testumgebung ausgeführt, Windows und Active Directory nicht ausgeführt, nicht unter Hyper-V.** Die Skripte der Module 2 bis 7 und 9 bis 13 (Python 3.13, `graphlib`, restic 0.16.4, `bc`) wurden in einem Cloud-Container ausgeführt; die Ausgaben stehen in den Ordnern `beispiele/` der Module. Modul 8 (Windows/Active Directory) beruht auf der Dokumentation von `wbadmin` auf Microsoft Learn (gelesen am 19.11.2026) und wurde nicht ausgeführt; die Schritte zur autoritativen Wiederherstellung sind Fachwissen und nicht bestätigt. **Alle Zahlen, Kontakte, Zeiten und Kosten in den Beispieldaten sind frei erfunden.** Das Szenario-Skript (Modul 12) ist ein Übungsmodell und keine Einsatzvorschrift. Normen (ISO 22301, BSI-Standard 200-4) wurden nicht gelesen. Offene Punkte: [`befehle-nicht-bestaetigt.md`](befehle-nicht-bestaetigt.md); Anmerkungen zum Lehrplan: [`lehrplan-korrekturen.md`](lehrplan-korrekturen.md).

## Umgebung

Eine Linux-VM `srv-lin01` (Debian 12, Python 3, restic, bc), für Modul 8 optional `srv-win01` (Windows Server mit Domänendiensten) unter **Hyper-V** am privaten Switch `Lab-Internal-Net` (`192.168.10.0/24`, statisch). Die Pakete werden vor Kursbeginn einmalig mit Internetzugang installiert (Details im Lehrplan). Das Labor wurde **nicht** aufgebaut.

## Module

| Nr. | Modul | Zeit | Prüfstand |
|---|---|---|---|
| 01 | [Grundlagen: Notfallmanagement, Business Continuity und Disaster Recovery](01-grundlagen-bcm-und-dr/) | 4,5 h | Entwurf, keine Befehle; Begriffe ohne geprüfte Quelle. |
| 02 | [Business-Impact-Analyse (BIA)](02-business-impact-analyse/) | 6,75 h | Skript im Container ausgeführt; Annahmen der Übung. |
| 03 | [Risikoanalyse für den IT-Betrieb](03-risikoanalyse/) | 6 h | Skript im Container ausgeführt; Skalen sind Annahmen. |
| 04 | [Wiederanlauf-Reihenfolge und Abhängigkeiten](04-wiederanlauf-reihenfolge/) | 6,75 h | Skript im Container ausgeführt; Dauern sind Annahmen. |
| 05 | [DR-Strategien und Standorte: kalt, warm, heiß, Cloud](05-dr-strategien-und-standorte/) | 6 h | Skript im Container ausgeführt; Werte sind erfunden. |
| 06 | [Alarmierung, Rollen und Kommunikation](06-alarmierung-und-kommunikation/) | 6 h | Skript im Container ausgeführt; keine echten Anrufe. |
| 07 | [Wiederherstellung unter Linux mit Zeitmessung](07-wiederherstellung-linux/) | 7,5 h | Skript im Container ausgeführt; Messwerte nicht übertragbar. |
| 08 | [Wiederherstellung unter Windows und Active Directory](08-wiederherstellung-windows-und-ad/) | 7,5 h | Nach Microsoft Learn gelesen, nicht ausgeführt; kein Skript. |
| 09 | [Das Notfallhandbuch: Aufbau, Prüfung und Pflege](09-notfallhandbuch/) | 6,75 h | Skript im Container ausgeführt; Pflichtabschnitte sind Annahmen. |
| 10 | [Notfallübung planen, durchführen und auswerten](10-notfalluebung/) | 7,5 h | Skript im Container ausgeführt; Protokoll erfunden. |
| 11 | [Lessons Learned und Maßnahmenverfolgung](11-lessons-learned-und-massnahmen/) (Priorität 2) | 4,5 h | Skript im Container ausgeführt; Liste erfunden. |
| 12 | [Szenario Cyberangriff: Reihenfolge der Schritte](12-cyberangriff-szenario/) (Priorität 2) | 6 h | Skript im Container ausgeführt; Übungsmodell, keine Einsatzvorschrift. |
| 13 | [Abschlussprojekt: DR-Plan prüfen und zusammenführen](13-abschluss-dr-plan/) | 7,5 h | Skript im Container ausgeführt; Schreibaufgabe. |

Summe 83,25 Stunden.

## Aufbau eines Moduls

Ordner `NN-kurzname/` mit `README.md`, der Übung `NN.1-….md` (Lernziele, Voraussetzungen, Grundbegriffe, Aufgaben, Hinweise, Kontrollfragen, einklappbare Musterlösung, Erweiterungen, Quellen), den Skripten und Beispieldaten des Moduls und einem Ordner `beispiele/` mit den echten Ausgaben der Läufe. Die Module 2, 3, 4, 6, 10, 11 und 13 arbeiten mit CSV-Dateien (Semikolon als Trenner), die mit den Skripten zusammen im Modulordner liegen; Modul 13 enthält Kopien der Daten aus den Modulen 2, 4, 6 und 11.

## Hinweise

- Die Skripte planen und rechnen, sie lösen keine Anrufe, Wiederherstellungen oder Netzwerkänderungen aus (außer `restore_zeit.sh`, das im Arbeitsordner eine Testwiederherstellung durchführt).
- Telefonnummern (`+43 000 …`), Namen und Firmen sind frei erfunden; echte Kontaktlisten gehören nicht in ein öffentliches Repository.
- Wiederherstellungen von Domänencontrollern (Modul 8) nur mit Hyper-V-Prüfpunkt im Lab.
- Aussagen zu Normen, Melde- und Aufbewahrungspflichten sind nicht geprüft und keine Rechtsberatung.

## Lizenz

- Skripte: MIT, siehe [`LICENSE`](LICENSE)
- Texte: CC BY 4.0, siehe [`LICENSE-DOCS.md`](LICENSE-DOCS.md)

*Lizenz: Text CC BY 4.0, Skripte MIT, siehe `LICENSE-DOCS.md` und `LICENSE` im Kursordner. Alle Personen, Firmen, Zahlen und Termine sind frei erfunden. Windows und Windows Server sind Marken der Microsoft Corporation; dieses Dokument steht in keiner Verbindung zu Microsoft.*
