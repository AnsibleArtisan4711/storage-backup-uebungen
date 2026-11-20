# Anmerkungen zum Lehrplan P34

Beim Ausarbeiten und Testen aufgefallene Punkte. Der Lehrplan selbst wurde zusammen mit der Übungsreihe erstellt und danach **nicht** verändert.

| Nr. | Modul | Befund | Vorschlag |
|---|---|---|---|
| 1 | alle | **Ausführung:** Alle Btrfs-Skripte liefen im Cloud-Container (Ubuntu 24.04, Kernel 6.18.44, `btrfs-progs` v6.6.3) auf **Loop-Geräten**. Das Verhalten auf Debian oder Ubuntu in Hyper-V mit echten (virtuellen) Platten und anderen Versionen wurde nicht getestet. | Übungen auf `fs01` nachvollziehen; Ausgaben vergleichen. |
| 2 | alle | **ZFS:** ZFS war im Container nicht verfügbar (kein Kernelmodul, keine Programme `zpool`/`zfs`). Alle ZFS-Inhalte sind Python-Modelle oder Textdateien aus Fachwissen und **nicht bestätigt**. | Auf einem Testsystem mit `zfsutils-linux` prüfen und Quellen eintragen. |
| 3 | alle | **Quellen:** Die Dokumentation von Btrfs und OpenZFS wurde nicht gelesen; Syntax, Standardwerte und Verhalten sind nicht bestätigt. | Quellen lesen und eintragen. |
| 4 | 03 | **UUID:** In der Ausgabe von `btrfs filesystem show` ist die UUID durch `<UUID>` ersetzt. | Auf `fs01` eigene Werte verwenden. |
| 5 | 06 | **Beschädigung simuliert:** Zufallsdaten werden direkt in die Image-Datei geschrieben; echte Plattenfehler verhalten sich anders. raid5/raid6 wurden nicht getestet. | Nie gegen echte Geräte ausführen. |
| 6 | 07 | **Priorität und lzo:** Modul 7 ist Priorität 2; kein anderes Modul setzt es voraus. `lzo` sparte im Lauf nur 1 % (99 %); die Ursache wurde **nicht untersucht**. | Bei Zeitmangel entfallen lassen; Ursache im Labor untersuchen. |
| 7 | 08 | **qgroups:** Einfluss der Quoten auf die Leistung wurde nicht gemessen (Fachwissen). | Messen, bevor Quoten im Betrieb eingesetzt werden. |
| 8 | 09 | **Degradierter Betrieb:** Nach dem Einbinden mit `-o degraded` entstanden Chunks im Profil `single`; erst die Balance mit `soft` stellte `raid1` wieder her. Das ist eine Beobachtung dieses Laufs. | Auf `fs01` wiederholen und dokumentieren. |
| 9 | 10 | **Metadaten-Engpass:** Ein voller Metadaten-Chunk trotz freiem Platz wurde nicht nachgestellt. | Im Labor ergänzen. |
