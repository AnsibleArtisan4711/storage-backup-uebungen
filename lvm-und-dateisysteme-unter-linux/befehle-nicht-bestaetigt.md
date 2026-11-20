# Befehle und Aussagen, die nicht bestätigt sind

Prüfliste für den ersten Durchlauf in den Hyper-V-VMs: Befund und Datum eintragen, danach den Hinweis in der Übung entfernen. Legende: **Q** = gegen Quelle gelesen; **L** = im Labor (Container) ausgeführt; **–** = weder noch.

| Modul | Befehl oder Aussage | Status | Nächster Schritt |
|---|---|---|---|
| alle | Aufbau des Hyper-V-Labors (privater Switch `Lab-LVM`, `lv01` mit vier Zusatzplatten), Installation von `lvm2`, `xfsprogs`, `quota`, `fdisk`, `mdadm` | – | laut Lehrplan aufbauen und prüfen |
| 01 | `sfdisk` (GPT und MBR), `sfdisk -l`; `grenzen.py` | L (Image-Datei); `lsblk`/`blkid` auf `lv01`: nicht ausgeführt | auf `lv01` mit echter Platte wiederholen |
| 02 | `pvcreate`, `vgcreate`, `vgextend`, `pvs`, `vgs`; `lvcreate` (scheitert im Container); `lvm_modell.py`; `beispiel_lv.txt` | L (PV und VG, Loop-Geräte); Logical Volumes: nicht ausgeführt (Text/Modell) | LV-Befehle auf `lv01` ausführen |
| 03 | `mkfs.ext4`, `mkfs.xfs`, `blkid`, `df`, `df -i`, `tune2fs -l`, `xfs_info`; `vergleich.py` | L (Loop-Geräte) | auf `lv01` wiederholen |
| 04 | `resize2fs`, `xfs_growfs`, `e2fsck -f -p`, `losetup -c` | L (ext4 nur ausgehängt; online verweigert); XFS-Verkleinerung abgelehnt; LVM: nicht ausgeführt | Online-Vergrößerung und `lvextend -r` auf `lv01` prüfen |
| 05 | `mount -o noexec|ro|remount`, `findmnt --verify --tab-file`; `fstab_pruefen.py` | L (Container); `fstab_pruefen.py`: eigene Beispielregeln | mit der echten `fstab` auf `lv01` prüfen |
| 06 | `quota_modell.py`; `beispiel_quota.txt` | nicht ausgeführt (Modell und Text) | auf `lv01` mit Quota-Option ausprobieren |
| 07 | `e2fsck -n|-fy`, `debugfs`, `xfs_repair -n`, `dd` (künstliche Beschädigung) | L (Image-Dateien) | weitere Fehlerbilder im Labor erzeugen |
| 08 | `mkfs.ext4 -N 200`, `df`, `df -i`, `du`, `find`; `schwelle.py`; `beispiel_mdadm_snapshot.txt` | L (Container); `schwelle.py`: erfundene Werte; `mdadm`, Snapshots: nicht ausgeführt | Überwachung mit echten `df`-Werten testen |
