# LVM und Dateisysteme unter Linux (P54)

Übungsreihe zu LVM und Dateisystemen unter Linux: Partitionierung (MBR, GPT), Physical Volumes, Volume Groups und Logical Volumes, ext4 und XFS im Vergleich, Vergrößern und Verkleinern, Mount-Optionen und fstab, Quotas, Fehlerdiagnose und Reparatur sowie Überwachung des Speicherplatzes. 8 Module, 104 Unterrichtseinheiten zu 45 Minuten, davon 1 Modul mit Priorität 2 (Vertiefung). Praxisübungen mit Loop-Geräten; Logical Volumes, Quotas und RAID als Modell und Text. Die Aufgabentexte und Kontrollfragen stammen aus dem Lehrplan P54 (Reihe „Lehrplan-Prompts“, Datei `P54-lvm-und-dateisysteme-unter-linux.md`) und sind unverändert; Hinweise, Musterlösungen und Ergänzungen sind Teil der Ausarbeitung und gekennzeichnet.

> **Prüfstand, ehrlich:** **Im Cloud-Container mit Loop-Geräten ausgeführt, nicht in Hyper-V.** Partitionen, Physical Volumes, Volume Groups, ext4 und XFS liefen mit `e2fsprogs` 1.47.0 und `lvm2` 2.03.16 (Ubuntu 24.04, Kernel 6.18.44); die Ausgaben stehen in den Ordnern `beispiele/`. Alle Daten sind erfunden. **Logical Volumes, Snapshots, `mdadm` und Quotas wurden nicht ausgeführt**: Diese Teile sind Modelle und Textdateien aus Fachwissen und nicht bestätigt. Bestätigt wurde das Verhalten der Programme in diesem Lauf, **nicht** gegen die Dokumentation. Offene Punkte: [`befehle-nicht-bestaetigt.md`](befehle-nicht-bestaetigt.md); Anmerkungen zum Lehrplan: [`lehrplan-korrekturen.md`](lehrplan-korrekturen.md).

## Umgebung

Eine Linux-VM unter **Hyper-V** (Lehrplan): `lv01` (`10.54.0.2`, Debian/Ubuntu Server) mit vier zusätzlichen virtuellen Platten am privaten Switch `Lab-LVM` (`10.54.0.0/24`). Das Labor wurde **nicht** aufgebaut. Die Skripte arbeiten stattdessen mit Image-Dateien unter `/tmp/p54` auf Loop-Geräten und brauchen `root`.

## Module

| Nr. | Modul | Zeit | Prüfstand |
|---|---|---|---|
| 01 | [Partitionierung: MBR und GPT](01-partitionierung-mbr-und-gpt/) | 9 h | Skripte im Container ausgeführt. |
| 02 | [Physical Volumes, Volume Groups und Logical Volumes](02-physical-volumes-volume-groups-logical-volumes/) | 10,5 h | PV und VG im Container geprüft; Logical Volumes nicht ausgeführt. |
| 03 | [Dateisysteme ext4 und XFS im Vergleich](03-ext4-und-xfs-im-vergleich/) | 10,5 h | Skripte im Container ausgeführt. |
| 04 | [Dateisysteme vergrößern und verkleinern](04-vergroessern-und-verkleinern/) | 10,5 h | ext4 und XFS im Container geprüft; LVM-Teile nicht ausgeführt. |
| 05 | [Mount-Optionen und fstab](05-mount-optionen-und-fstab/) | 9 h | Skripte im Container ausgeführt. |
| 06 | [Quotas](06-quotas/) (Priorität 2) | 9 h | Nur Modell und Text; nicht im Container ausgeführt. |
| 07 | [Fehlerdiagnose und Reparatur](07-fehlerdiagnose-und-reparatur/) | 10,5 h | Skripte im Container ausgeführt. |
| 08 | [Überwachung des Speicherplatzes](08-ueberwachung-des-speicherplatzes/) | 9 h | Skripte im Container ausgeführt; RAID und Snapshots nicht ausgeführt. |

Summe 78 Stunden.

## Aufbau eines Moduls

Ordner `NN-kurzname/` mit `README.md`, der Übung `NN.1-….md` (Lernziele, Voraussetzungen, Grundbegriffe, Aufgaben, Hinweise, Kontrollfragen, einklappbare Musterlösung, Erweiterungen, Quellen), den Skripten und Beispieldaten des Moduls und einem Ordner `beispiele/` mit den echten Ausgaben der Läufe. Die Skripte der Module liegen im jeweiligen Modulordner und binden `../lab.sh` ein.

## Hinweise

- Die Skripte legen Loop-Geräte und Dateisysteme an und entfernen sie am Ende (`lab_down`). **Nicht auf einem Rechner mit wichtigen Daten ausführen**; sie schreiben nur unter `/tmp/p54`, binden aber Loop-Geräte und Dateisysteme ein.
- Die Skripte `fsck_ext4.sh` und `xfs_repair.sh` beschädigen absichtlich Image-Dateien. **Niemals gegen echte Geräte ausführen.**
- Alle Namen, Adressen (`10.54.0.0/24`) und Daten sind erfunden.
- Befehle in `beispiel_*.txt` und in den Modellen wurden nicht ausgeführt und nicht gegen die Dokumentation geprüft.

## Lizenz

- Skripte: MIT, siehe [`LICENSE`](LICENSE)
- Texte: CC BY 4.0, siehe [`LICENSE-DOCS.md`](LICENSE-DOCS.md)

*Lizenz: Text CC BY 4.0, Skripte MIT, siehe `LICENSE-DOCS.md` und `LICENSE` im Kursordner. Alle Personen, Firmen, Zahlen und Termine sind frei erfunden. Windows und Windows Server sind Marken der Microsoft Corporation; dieses Dokument steht in keiner Verbindung zu Microsoft.*
