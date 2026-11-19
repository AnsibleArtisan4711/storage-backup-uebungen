# Befehle und Aussagen, die nicht bestätigt sind

Prüfliste für den ersten Durchlauf in den Hyper-V-VMs: Befund und Datum eintragen, danach den Hinweis in der Übung entfernen. Legende: **Q** = gegen Quelle gelesen; **L** = im Labor (Container) ausgeführt; **–** = weder noch.

| Modul | Befehl oder Aussage | Status | Nächster Schritt |
|---|---|---|---|
| alle | Aufbau des Hyper-V-Labors, Prüfpunkte, Internetphase mit Paketinstallation | – | laut Lehrplan aufbauen und prüfen |
| 01, 03 | Aussagen zu RAID, Replikation, Archiv sowie Regel 3-2-1 und 3-2-1-1-0 (Zählweise) | – | gegen Quellen prüfen; die Zählweise ist eine Auslegung |
| 02 | `rpo_rto.py` (Rechenmodell), Rückgabewert 1 bei verfehlten Zielen | L (Python 3.13) | wiederholen |
| 03 | `dreizweieins.py` | L | wiederholen |
| 04 | `tar --listed-incremental` (Voll, Inkrement, Zurückspielen mit `=/dev/null`), Kettenbruch (fehlende neue Datei) | L (tar 1.35) | gegen Handbuch lesen; auf Debian 12 wiederholen |
| 05 | `rsync --link-dest`, Hardlink-Zähler, Rückgabewerte 23/24, Quick-Check-Fallstrick | L (rsync 3.2.7) | Rückgabewerte gegen das Handbuch lesen |
| 06 | `wbadmin start backup`, `get versions`, `get items`, `start recovery`, `start systemstatebackup`; `robocopy` (Optionen, Rückgabewerte 0 bis 7) | Q (Microsoft Learn), nicht ausgeführt | in `srv-win01` ausführen |
| 06 | `sicherung_windows.ps1` | L (nur Parser, PowerShell 7.4.6) | in der VM ausführen; Texte der deutschen Oberfläche eintragen |
| 06 | `vssadmin list writers/providers`, `diskshadow` | Q, nicht ausgeführt | in der VM ausführen |
| 06 | Name des Windows-Features für Windows Server Backup (`Install-WindowsFeature`) | – | mit `Get-WindowsFeature` ermitteln |
| 07 | `restic init/backup/snapshots/diff/stats/restore/check` | L (restic 0.16.4) | mit der Debian-12-Version wiederholen (vermutlich älter, andere Ausgabe) |
| 08 | `restic forget --dry-run`, `--keep-*`, `--prune`, `backup --time`; GFS-Simulation `gfs.py` | L | Zeitzonen- und Wochenregeln gegen Dokumentation prüfen |
| 09 | `gpg --symmetric`, `openssl enc -pbkdf2`, `restic key add/remove` | L (gpg 2.4.4, openssl 3.0.13) | Aussage zu AES-CBC ohne Integritätsschutz messen oder belegen |
| 10 | `chattr +i` und Verhalten von rsync/rm auf geschütztem Ziel | L (Container; Dateisystem nicht geprüft) | auf ext4 in der VM wiederholen; Verhalten auf Netzfreigaben prüfen |
| 11 | `restic check` mit und ohne `--read-data`, Rückgabewerte (rsync 23, tar 2, restic 1) | L | Rückgabewerte gegen Handbücher lesen |
| 12 | `db_sicherung.py` (SQLite-Backup-API, Textdump), Journal-Modi | L (SQLite 3.45.1) | Fehlerfall der Dateikopie war nicht reproduzierbar; mit größerer Datenbank versuchen |
| 12 | `pg_dump`, kontinuierliche Archivierung (PostgreSQL) | – | mit PostgreSQL-Server ausführen |
| 13 | `bericht.py`, Grenzwerte (26 h, 90 Tage) | L | Grenzwerte mit betrieblichen Vorgaben abgleichen |
