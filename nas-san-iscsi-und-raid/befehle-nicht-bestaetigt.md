# Befehle und Aussagen, die nicht bestätigt sind

Prüfliste für den ersten Durchlauf in den Hyper-V-VMs: Befund und Datum eintragen, danach den Hinweis in der Übung entfernen. Legende: **Q** = gegen Quelle gelesen; **L** = im Labor (Container) ausgeführt; **–** = weder noch.

| Modul | Befehl oder Aussage | Status | Nächster Schritt |
|---|---|---|---|
| alle | Aufbau des Hyper-V-Labors (privater Switch `Lab-Storage`, `stor01` mit vier Platten, `init01`) | – | laut Lehrplan aufbauen und prüfen |
| 01 | `blkid`, `blockdev --getsize64`, `mkfs.ext4`, `mount`, `df -T` auf einem Loop-Gerät | L (Ubuntu 24.04, e2fsprogs 1.47.0) | auf `stor01` mit echter Platte (z. B. `/dev/sdb`) wiederholen |
| 02 | `raid_rechner.py` (Kapazität, Schreibaufwand, URE-Risiko) | L (Python-Modell, Annahmen) | URE-Angaben aus Datenblättern prüfen |
| 03 | `xor_raid.py` (Parität, Write Hole); `mdadm --create` (Fehlermeldung) | L (Modell); `mdadm` 4.3 nur Fehlermeldung | `mdadm --create`, `--detail`, `--fail`, `--add` auf `stor01` ausführen |
| 04 | `mkfs.xfs`, `xfs_info`, `xfs_growfs`, `xfs_repair -n`, `resize2fs`, `e2fsck -fn`, `losetup -c` | L (xfsprogs 6.6.0, e2fsprogs 1.47.0) | auf `stor01` wiederholen; Online-Vergrößerung von ext4 prüfen |
| 05 | `freigaben_pruefen.py` (Textprüfung von `exports` und `smb.conf`) | L (Python); NFS und Samba – | Freigaben auf `stor01` einrichten und von `init01` einbinden |
| 06 | `tgtd -f --iscsi portal=…`, `tgtadm --lld iscsi --mode target/logicalunit/account …` | L (tgt 1.0.85, Userspace) | auf `stor01` mit `systemd` und echter Platte wiederholen |
| 07 | `iscsi-ls`, `iscsi-inq`, `iscsi-readcapacity16` (libiscsi 1.19.0); `iqn_pruefen.py` | L (Userspace-Initiator); `iscsiadm` – | auf `init01` mit `open-iscsi` bzw. Windows-Initiator |
| 08 | `multipfad_modell.py`; `multipath-tools` | L (Modell); `multipath-tools` – | mit zwei Portalen auf `stor01` prüfen |
| 09 | `kapazitaet.py` (erfundene Zahlen) | L (Python-Modell) | mit echten Messwerten rechnen |
| 10 | `smartctl -i` auf Loop-Gerät; `smart_auswerten.py` (erfundene Ausgabe) | L (smartmontools 7.4); echtes SMART – | `smartctl -A` an echter Platte am Host prüfen |
| 11 | `ausfall_planung.py` (Rebuild-Zeit, USV-Laufzeit) | L (Python-Modell, Annahmen) | mit Messwerten und echter USV prüfen |
