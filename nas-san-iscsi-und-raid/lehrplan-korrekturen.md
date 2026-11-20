# Anmerkungen zum Lehrplan P33

Beim Ausarbeiten und Testen aufgefallene Punkte. Der Lehrplan selbst wurde zusammen mit der Übungsreihe erstellt und danach **nicht** verändert.

| Nr. | Modul | Befund | Vorschlag |
|---|---|---|---|
| 1 | alle | **Laborbeschreibung:** Der Lehrplan nennt „1x Linux-Server-VM mit mehreren virtuellen Platten; 1x Initiator-VM; privater Hyper-V-Switch“; die Skripte bilden das Labor mit Loop-Geräten und einem Userspace-`tgtd` nach (kein `systemd`, kein Kernel-Initiator, kein md-RAID). | Skripte erstmals in Hyper-V ausführen; Gerätenamen anpassen. |
| 2 | 03 | **Software-RAID:** `mdadm --create` schlug im Container fehl (kein md-Kernelmodul); das RAID-Verhalten wird nur als Python-Modell gezeigt. | Auf `stor01` mit echten Platten nachvollziehen. |
| 3 | 04 | **ext4 online vergrößern:** Im Container blieb die Größe nach `resize2fs` am eingebundenen Loop-Gerät unverändert; das Skript vergrößert ext4 deshalb ausgehängt. Ursache nicht untersucht. | Auf `stor01` das Online-Vergrößern mit echter Platte prüfen. |
| 4 | 05 | **NFS und SMB:** Es wurde weder NFS noch Samba ausgeführt; Parameternamen stammen aus Fachwissen. | Mit `nfs-kernel-server` und `samba` prüfen. |
| 5 | 07 | **Initiator:** Der Kernel-Initiator (`iscsiadm`) ließ sich im Container nicht verwenden; die libiscsi-Werkzeuge ersetzen ihn für Abfragen. | Auf `init01` mit `open-iscsi` prüfen. |
| 6 | 08 | **Priorität:** Modul 8 ist Priorität 2; kein anderes Modul setzt es voraus. | Bei Zeitmangel entfallen lassen. |
| 7 | alle | **Quellen:** Weder die Dokumentation der Werkzeuge noch die RFCs wurden gelesen; alle Zahlen zu Fehlerraten, Wachstum und USV sind Annahmen. | Quellen lesen und eintragen. |
