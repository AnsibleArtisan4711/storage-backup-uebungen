# NAS, SAN, iSCSI und RAID (P33)

Übungsreihe zu Speichertechnik: Speicherarten (DAS, NAS, SAN), RAID-Stufen und Parität, Dateisysteme (ext4, XFS), NAS mit NFS und SMB, iSCSI (Target und Initiator), Multipath im Überblick, Kapazitätsplanung, SMART und Überwachung sowie Ausfall, Wiederherstellung und USV. 11 Module, 120 Unterrichtseinheiten zu 45 Minuten, davon 1 Modul mit Priorität 2 (Vertiefung). Die Aufgabentexte und Kontrollfragen stammen aus dem Lehrplan P33 (Reihe „Lehrplan-Prompts“, Datei `P33-nas-san-iscsi-und-raid.md`) und sind unverändert; Hinweise, Musterlösungen und Ergänzungen sind Teil der Ausarbeitung und gekennzeichnet.

> **Prüfstand, ehrlich:** **In einem Cloud-Container (Ubuntu 24.04) mit Loop-Geräten ausgeführt, nicht in Hyper-V.** Alle Skripte der Module 1 bis 11 liefen mit e2fsprogs 1.47.0, xfsprogs 6.6.0, tgt 1.0.85 (Userspace), libiscsi 1.19.0, smartmontools 7.4 und Python 3; die Ausgaben stehen in den Ordnern `beispiele/`. Ein echtes `mdadm`-RAID war nicht möglich (Fehlermeldung in Modul 3), RAID und SMART werden als Modell gezeigt. Nicht ausgeführt: Hyper-V-Labor, NFS und Samba, Kernel-Initiator, Multipath, echte Platten. Offene Punkte: [`befehle-nicht-bestaetigt.md`](befehle-nicht-bestaetigt.md); Anmerkungen zum Lehrplan: [`lehrplan-korrekturen.md`](lehrplan-korrekturen.md).

## Umgebung

Zwei VMs unter **Hyper-V** (Lehrplan): `stor01` (`10.33.0.2`, vier zusätzliche Platten zu je 2 GB) und `init01` (`10.33.0.10`) am privaten Switch `Lab-Storage` (`10.33.0.0/24`). Das Labor wurde **nicht** aufgebaut. Die Skripte arbeiten stattdessen mit **Loop-Geräten** und Image-Dateien unter `/tmp/p33` und einer Userspace-Instanz von `tgtd` auf `127.0.0.1:3260`. Voraussetzungen im Testrechner: root, `e2fsprogs`, `xfsprogs`, `tgt`, `libiscsi-bin`, `smartmontools`, `mdadm`, `python3`.

## Module

| Nr. | Modul | Zeit | Prüfstand |
|---|---|---|---|
| 01 | [Speicherarten: DAS, NAS, SAN und der Unterschied zwischen Block und Datei](01-speicherarten-und-blockgeraete/) | 7,5 h | Skript im Container (Loop-Gerät) ausgeführt. |
| 02 | [RAID-Stufen und ihre Wahl](02-raid-stufen-und-wahl/) | 9 h | Skript im Container ausgeführt (Modell). |
| 03 | [Parität verstehen: XOR, Rekonstruktion und Write Hole](03-paritaet-und-ausfall/) | 9 h | Modell ausgeführt; `mdadm --create` im Container nicht möglich. |
| 04 | [Dateisysteme: ext4 und XFS anlegen, vergrößern und prüfen](04-dateisysteme-ext4-und-xfs/) | 9 h | Skript im Container (Loop-Geräte) ausgeführt. |
| 05 | [NAS-Grundlagen: NFS und SMB und die Prüfung von Freigaben](05-nas-mit-nfs-und-smb/) | 7,5 h | Textprüfung ausgeführt; kein Server verwendet. |
| 06 | [iSCSI: Target mit tgt einrichten](06-iscsi-target/) | 9 h | Skript im Container ausgeführt (Userspace-tgtd). |
| 07 | [iSCSI: Initiator, Namen und Zugriffsschutz prüfen](07-iscsi-initiator/) | 9 h | Skript im Container (libiscsi, Userspace) ausgeführt. |
| 08 | [Multipath im Überblick](08-multipath-im-ueberblick/) (Priorität 2) | 6 h | Modell ausgeführt; kein echtes Multipath. |
| 09 | [Kapazitätsplanung](09-kapazitaetsplanung/) | 7,5 h | Skript im Container ausgeführt (Modell). |
| 10 | [SMART und Überwachung](10-smart-und-ueberwachung/) | 7,5 h | Skript ausgeführt; kein echtes SMART verfügbar. |
| 11 | [Ausfall, Wiederherstellung, Schreib-Cache und USV](11-ausfall-rebuild-und-usv/) | 9 h | Skript im Container ausgeführt (Modell). |

Summe 90 Stunden.

## Aufbau eines Moduls

Ordner `NN-kurzname/` mit `README.md`, der Übung `NN.1-….md` (Lernziele, Voraussetzungen, Grundbegriffe, Aufgaben, Hinweise, Kontrollfragen, einklappbare Musterlösung, Erweiterungen, Quellen), den Skripten und Beispieldaten des Moduls und einem Ordner `beispiele/` mit den echten Ausgaben der Läufe. Die Skripte der Module liegen im jeweiligen Modulordner und binden `../lab.sh` ein.

## Hinweise

- Die Skripte legen Loop-Geräte und Dateisysteme unter `/tmp/p33` an, starten und beenden `tgtd` und entfernen am Ende alles (`lab_down`). **Nicht auf einem Rechner mit wichtigen Loop-Geräten oder einem produktiven `tgtd` ausführen.**
- Alle Namen (IQN `iqn.2026-11.example.com:…`), Adressen (`10.33.0.0/24`) und Konten sind erfunden; verwendet wird nur die reservierte Domain `example.com`.
- Das CHAP-Kennwort in den Skripten (`geheim123456`) ist ein Testwert im Klartext. **Niemals für echte Konten verwenden.**
- Die Prüfskripte in Modul 5 und 10 lesen nur Textdateien; die Beispieldateien sind erfunden.

## Lizenz

- Skripte: MIT, siehe [`LICENSE`](LICENSE)
- Texte: CC BY 4.0, siehe [`LICENSE-DOCS.md`](LICENSE-DOCS.md)

*Lizenz: Text CC BY 4.0, Skripte MIT, siehe `LICENSE-DOCS.md` und `LICENSE` im Kursordner. Alle Personen, Firmen, Zahlen und Termine sind frei erfunden. Windows und Windows Server sind Marken der Microsoft Corporation; dieses Dokument steht in keiner Verbindung zu Microsoft.*
