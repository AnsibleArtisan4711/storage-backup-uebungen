# Befehle und Aussagen, die nicht bestätigt sind

Prüfliste für den ersten Durchlauf in den Hyper-V-VMs: Befund und Datum eintragen, danach den Hinweis in der Übung entfernen. Legende: **Q** = gegen Quelle gelesen; **L** = im Labor (Container) ausgeführt; **–** = weder noch.

| Modul | Befehl oder Aussage | Status | Nächster Schritt |
|---|---|---|---|
| alle | Aufbau des Hyper-V-Labors (privater Switch `Lab-Dateidienste`, `fs01`, `win11`, `lx01`), Installation von `samba`, `acl`, `nfs-kernel-server`, `cifs-utils`, `nfs-common` | – | laut Lehrplan aufbauen und prüfen |
| 01 | `protokolle.py` | L (Tabelle ausgeführt; drei Zeilen mit L, fünf mit F) | Aussagen mit der Dokumentation prüfen |
| 02 | `testparm -s`, `useradd`, `smbpasswd -a -s`, `pdbedit -L`, `smbd -D`, `smbclient -L/-c put/ls` | L (Samba 4.19.5, Loopback, Port 4455); Windows- und `cifs`-Zugriff: nicht ausgeführt | auf `fs01` mit Port 445 und von `win11`/`lx01` wiederholen |
| 03 | `valid users`, `write list`, `force group`, `create mask`, `chgrp`, `chmod 2770`, `smbclient put/get/ls` | L (Loopback) | mit `win11` wiederholen |
| 04 | `setfacl -m`, `setfacl -d -m`, `getfacl -p`, `inherit acls` | L (Loopback) | Windows-Sicht der ACLs prüfen |
| 05 | `testparm -s domaene_smb.conf`; `beitritt.txt` (`kinit`, `net ads join`, `wbinfo -u`, `net ads testjoin`) | Syntax: L; Beitritt: nicht ausgeführt | mit `dc01` ausprobieren |
| 06 | `exports_pruefen.py`; `beispiel_nfs.txt` (`exportfs`, `showmount`, `mount -t nfs4`) | nicht ausgeführt (Modell und Text) | auf `fs01` und `lx01` ausführen |
| 07 | `server min protocol`, `server signing`, `server smb encrypt`, `smbclient -m`, `--client-protection=encrypt` | L (Loopback) | mit `win11` prüfen |
| 08 | `testparm`, `smbclient`, `tar --acls --xattrs`, `getfacl` | L (Loopback) | Wiederherstellung auf `fs01` üben |
