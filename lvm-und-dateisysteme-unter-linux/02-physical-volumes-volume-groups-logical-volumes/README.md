# 02 LVM-Aufbau

Übung **02.1** (Priorität 1). Geschätzte Zeit: 8 bis 11 Stunden (Schätzung; Lehrplan: 14 UE zu 45 Minuten = 10,5 Stunden).

> PV und VG im Container geprüft; Logical Volumes nicht ausgeführt.

| Datei | Zweck |
|---|---|
| `02.1-physical-volumes-volume-groups-logical-volumes.md` | Die Übung mit Aufgaben, Kontrollfragen und Musterlösung |
| `beispiel_lv.txt` | Befehle für Logical Volumes (NICHT AUSGEFÜHRT: im Test-Container fehlt Device-Mapper; aus Fachwissen, nicht bestätigt) |
| `lauf.sh` | Skript |
| `lvm_modell.py` | Modell: Extents einer Volume Group verteilen (linear). Vereinfacht; kein Abbild von LVM-Metadaten. Erfundene Größen. |
| `lvm_vg.sh` | LVM-Metadaten: Physical Volumes und Volume Group auf Loop-Geräten (Logical Volumes sind im Container nicht möglich, kein Device-Mapper). |
| `beispiele/lauf.ausgabe.txt` | Echte Ausgabe des Laufs von `lauf` |
| `beispiele/lvm_vg.ausgabe.txt` | Echte Ausgabe des Laufs von `lvm_vg` |
