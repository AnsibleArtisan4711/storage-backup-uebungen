# Befehle und Aussagen, die nicht bestätigt sind

Prüfliste für den ersten Durchlauf in den Hyper-V-VMs: Befund und Datum eintragen, danach den Hinweis in der Übung entfernen. Legende: **Q** = gegen Quelle gelesen; **L** = im Labor (Container) ausgeführt; **–** = weder noch.

| Modul | Befehl oder Aussage | Status | Nächster Schritt |
|---|---|---|---|
| alle | Aufbau des Hyper-V-Labors (privater Switch `Lab-FS`, `fs01` mit vier Zusatzplatten), Installation von `btrfs-progs` | – | laut Lehrplan aufbauen und prüfen |
| 01 | `btrfs filesystem du`, `cp --reflink=always`, `filefrag`; `cow_modell.py` | L (Loop-Gerät, Container); Modell: eigenes Beispiel | auf `fs01` mit echter Platte wiederholen |
| 02 | `btrfs --version`, `btrfs inspect-internal dump-super`, `btrfs filesystem df`, Prüfung von `/proc/filesystems`; `vergleich.py` | L (Btrfs); ZFS: nicht ausgeführt (F) | ZFS-Aussagen mit Dokumentation und Testsystem prüfen |
| 03 | `mkfs.btrfs -d raid1 -m raid1`, `btrfs subvolume create/list`, `mount -o subvol`, `btrfs filesystem show/usage`; `zfs_modell.py`; `beispiel_zfs.txt` | L (Btrfs); ZFS: Modell und Text (nicht ausgeführt) | auf `fs01` mit den Zusatzplatten wiederholen |
| 04 | `btrfs subvolume snapshot [-r]`, `btrfs subvolume delete`; `rotation.py`; `zfs_snapshots_modell.py` | L (Btrfs); Rotation und ZFS: Modell | Rotation auf `fs01` als Zeitplan testen |
| 05 | `btrfs send [-p]`, `btrfs receive`; `replikationsplan.py` (ZFS-Befehle als Text) | L (zwei Loop-Geräte, ein Rechner); ssh: –; ZFS: nicht ausgeführt | Übertragung zwischen zwei Systemen über ssh testen |
| 06 | `btrfs scrub start -B`, `btrfs device stats`; `pruefsumme_modell.py` | L (simulierte Beschädigung im Image) | mit echten Platten und regelmäßigem Scrub testen |
| 07 | `mount -o compress=zstd|zlib|lzo`, `compress-force`, `btrfs filesystem defragment -c`, `compsize`; `kompression_modell.py` | L (Container; `lzo`-Ergebnis nicht untersucht) | mit eigenen Daten und Kompressionsstufen messen |
| 08 | `btrfs filesystem usage`, `btrfs quota enable`, `btrfs qgroup limit/show`, `btrfs device add/remove`, `btrfs balance start -dconvert`; `quoten_zfs_modell.py` | L (Btrfs); ZFS: Modell | Auswirkung der Quoten auf die Leistung messen |
| 09 | `cp --reflink`, Rollback durch `mv` und Snapshot, `mount -o degraded`, `btrfs replace start`, `btrfs balance -dconvert=raid1,soft`; `beispiel_zfs_wiederherstellung.txt` | L (simulierter Ausfall); ZFS: Text (nicht ausgeführt) | echten Plattentausch auf `fs01` üben |
| 10 | `btrfs filesystem usage`, `btrfs subvolume list -s`; `diagnose.py` | L (Container) | Metadaten-Engpass im Labor nachstellen |
