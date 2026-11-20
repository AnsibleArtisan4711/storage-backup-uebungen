# Anmerkungen zum Lehrplan P54

Beim Ausarbeiten und Testen aufgefallene Punkte. Der Lehrplan selbst wurde zusammen mit der Übungsreihe erstellt und danach **nicht** verändert.

| Nr. | Modul | Befund | Vorschlag |
|---|---|---|---|
| 1 | alle | **Ausführung:** Alle Skripte liefen im Cloud-Container (Ubuntu 24.04, Kernel 6.18.44, `e2fsprogs` 1.47.0, `lvm2` 2.03.16) auf **Loop-Geräten**. Das Verhalten auf Debian oder Ubuntu in Hyper-V mit anderen Versionen wurde nicht getestet. | Übungen auf `lv01` nachvollziehen; Ausgaben vergleichen. |
| 2 | alle | **Nicht ausführbar im Container:** Logical Volumes und Snapshots (kein Device-Mapper), `mdadm` (kein `md`), Quotas (Einbinden mit Quota-Option scheiterte) und die Online-Vergrößerung von ext4. Diese Teile sind Modelle oder Textdateien aus Fachwissen und **nicht bestätigt**. | Auf `lv01` ausführen und Ergebnis eintragen. |
| 3 | alle | **Quellen:** Die Handbücher von LVM, ext4, XFS und `mdadm` wurden nicht gelesen; Syntax, Standardwerte und Verhalten sind nicht bestätigt. | Quellen lesen und eintragen. |
| 4 | 02 | **Modell gegen echte Werte:** `lvm_modell.py` hat 150 Extents, die echte Volume Group 148 (Metadatenbereich je PV). Die Zahlen sind erfunden. | Modell als Veranschaulichung verstehen, nicht als Vorhersage. |
| 5 | 03 | **XFS-Mindestgröße:** XFS lehnte Images unter 300 MiB ab; das ist ein Wert dieses Laufs. | Mit der eingesetzten Version prüfen. |
| 6 | 04 | **Verkleinern:** ext4 wurde ausgehängt verkleinert (80M, zeigt 70M); XFS meldete „Invalid argument“. Ob andere Versionen XFS verkleinern können, wurde nicht geprüft. | Dokumentation der eingesetzten Version lesen. |
| 7 | 06 | **Priorität:** Modul 6 ist Priorität 2; kein anderes Modul setzt es voraus. Quotas wurden nicht ausgeführt. | Bei Zeitmangel entfallen lassen; auf `lv01` testen. |
| 8 | 07 | **Beschädigung künstlich:** `debugfs` und `dd` erzeugen definierte Fehler im Image; echte Fehler verhalten sich anders. Nie gegen echte Geräte ausführen. | Im Labor mit Abbild üben. |
| 9 | 08 | **Inodes:** Das Dateisystem hat absichtlich 200 Inodes; `schwelle.py` nutzt erfundene Werte. | Echte Werte auf `lv01` einlesen. |
