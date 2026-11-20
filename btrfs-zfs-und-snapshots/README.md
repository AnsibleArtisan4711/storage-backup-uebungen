# Btrfs, ZFS und Snapshots (P34)

Übungsreihe zu Btrfs, ZFS und Snapshots: Copy-on-Write, Vergleich beider Dateisysteme, Pools, Subvolumes und Datasets, Snapshots und Klone, Replikation mit send/receive, Prüfsummen und Scrub, Kompression, Speicherverwaltung und Quoten, Wiederherstellung sowie typische Fehler. 10 Module, 108 Unterrichtseinheiten zu 45 Minuten, davon 1 Modul mit Priorität 2 (Vertiefung). Praxisübungen mit Btrfs; ZFS als Modell und Überblick. Die Aufgabentexte und Kontrollfragen stammen aus dem Lehrplan P34 (Reihe „Lehrplan-Prompts“, Datei `P34-btrfs-zfs-und-snapshots.md`) und sind unverändert; Hinweise, Musterlösungen und Ergänzungen sind Teil der Ausarbeitung und gekennzeichnet.

> **Prüfstand, ehrlich:** **Im Cloud-Container mit Loop-Geräten ausgeführt, nicht in Hyper-V.** Alle Btrfs-Skripte liefen mit `btrfs-progs` v6.6.3 (Ubuntu 24.04, Kernel 6.18.44); die Ausgaben stehen in den Ordnern `beispiele/`. Alle Daten sind erfunden. **ZFS wurde nicht ausgeführt**: Die ZFS-Teile sind Modelle und Textdateien aus Fachwissen und nicht bestätigt. Bestätigt wurde das Verhalten der Programme in diesem Lauf, **nicht** gegen die Dokumentation. Offene Punkte: [`befehle-nicht-bestaetigt.md`](befehle-nicht-bestaetigt.md); Anmerkungen zum Lehrplan: [`lehrplan-korrekturen.md`](lehrplan-korrekturen.md).

## Umgebung

Eine Linux-VM unter **Hyper-V** (Lehrplan): `fs01` (`10.34.0.2`, Debian/Ubuntu Server) mit vier zusätzlichen virtuellen Platten am privaten Switch `Lab-FS` (`10.34.0.0/24`). Das Labor wurde **nicht** aufgebaut. Die Skripte arbeiten stattdessen mit Image-Dateien unter `/tmp/p34` auf Loop-Geräten und brauchen `root`.

## Module

| Nr. | Modul | Zeit | Prüfstand |
|---|---|---|---|
| 01 | [Copy-on-Write](01-copy-on-write/) | 7,5 h | Skripte im Container ausgeführt. |
| 02 | [Btrfs und ZFS im Vergleich](02-btrfs-und-zfs-im-vergleich/) | 7,5 h | Btrfs im Container geprüft; ZFS nicht ausgeführt. |
| 03 | [Pools, Subvolumes und Datasets](03-pools-subvolumes-und-datasets/) | 9 h | Btrfs-Skripte im Container ausgeführt; ZFS als Modell. |
| 04 | [Snapshots und Klone](04-snapshots-und-klone/) | 9 h | Btrfs-Skripte im Container ausgeführt; ZFS als Modell. |
| 05 | [Replikation mit send und receive](05-replikation-mit-send-und-receive/) | 9 h | Btrfs-Skripte im Container ausgeführt; ZFS als Text. |
| 06 | [Prüfsummen und Scrub](06-pruefsummen-und-scrub/) | 7,5 h | Btrfs-Skripte im Container ausgeführt. |
| 07 | [Kompression](07-kompression/) (Priorität 2) | 6 h | Btrfs-Skripte im Container ausgeführt; ZFS nicht ausgeführt. |
| 08 | [Speicherverwaltung und Quoten](08-speicherverwaltung-und-quoten/) | 9 h | Btrfs-Skripte im Container ausgeführt; ZFS als Modell. |
| 09 | [Wiederherstellung](09-wiederherstellung/) | 9 h | Btrfs-Skripte im Container ausgeführt; ZFS als Text. |
| 10 | [Typische Fehler und ihre Diagnose](10-typische-fehler/) | 7,5 h | Btrfs-Skripte im Container ausgeführt. |

Summe 81 Stunden.

## Aufbau eines Moduls

Ordner `NN-kurzname/` mit `README.md`, der Übung `NN.1-….md` (Lernziele, Voraussetzungen, Grundbegriffe, Aufgaben, Hinweise, Kontrollfragen, einklappbare Musterlösung, Erweiterungen, Quellen), den Skripten und Beispieldaten des Moduls und einem Ordner `beispiele/` mit den echten Ausgaben der Läufe. Die Skripte der Module liegen im jeweiligen Modulordner und binden `../lab.sh` ein.

## Hinweise

- Die Skripte legen Loop-Geräte und Dateisysteme an und entfernen sie am Ende (`lab_down`). **Nicht auf einem Rechner mit wichtigen Daten ausführen**; die Skripte schreiben nur unter `/tmp/p34`, binden aber Loop-Geräte und Dateisysteme ein.
- Das Skript `scrub_btrfs.sh` beschädigt absichtlich Image-Dateien. **Niemals gegen echte Geräte ausführen.**
- Alle Namen, Adressen (`10.34.0.0/24`) und Daten sind erfunden.
- ZFS-Befehle in `beispiel_zfs*.txt` und in den Modellen wurden nicht ausgeführt und nicht gegen die Dokumentation geprüft.

## Lizenz

- Skripte: MIT, siehe [`LICENSE`](LICENSE)
- Texte: CC BY 4.0, siehe [`LICENSE-DOCS.md`](LICENSE-DOCS.md)

*Lizenz: Text CC BY 4.0, Skripte MIT, siehe `LICENSE-DOCS.md` und `LICENSE` im Kursordner. Alle Personen, Firmen, Zahlen und Termine sind frei erfunden. Windows und Windows Server sind Marken der Microsoft Corporation; dieses Dokument steht in keiner Verbindung zu Microsoft.*
