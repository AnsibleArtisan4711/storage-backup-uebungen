# Anmerkungen zum Lehrplan P55

Beim Ausarbeiten und Testen aufgefallene Punkte. Der Lehrplan selbst wurde zusammen mit der Übungsreihe erstellt und danach **nicht** verändert.

| Nr. | Modul | Befund | Vorschlag |
|---|---|---|---|
| 1 | alle | **Ausführung:** Alle Samba-Skripte liefen im Cloud-Container (Ubuntu 24.04, Kernel 6.18.44, Samba 4.19.5) mit `smbclient` über Loopback auf Port 4455. Das Verhalten von Windows- und Linux-Clients in Hyper-V und mit anderen Versionen wurde nicht getestet. | Übungen auf `fs01`, `win11` und `lx01` nachvollziehen. |
| 2 | alle | **Nicht ausführbar im Container:** NFS (kein NFS im Kernel), Windows-Clients und der Domänenbeitritt. Diese Teile sind Modelle oder Textdateien aus Fachwissen und **nicht bestätigt**. | Auf den VMs ausführen und Ergebnis eintragen. |
| 3 | alle | **Quellen:** Die Handbücher von Samba und NFS wurden nicht gelesen. | Quellen lesen und eintragen. |
| 4 | 02 | **Standardmaske:** Die über Samba angelegte Datei hatte die Rechte `rwxr--r--`; das ist ein Wert dieses Laufs und kann je Version abweichen. | Auf `fs01` prüfen. |
| 5 | 04 | **Maske:** Die effektiven Rechte der neuen Datei waren `r--`; die Ursache wurde nur vermutet (Standardmaske). | Mit `create mask` im Labor untersuchen. |
| 6 | 05 | **Priorität:** Modul 5 ist Priorität 2; kein anderes Modul setzt es voraus. `testparm` prüft nur die Syntax. | Bei Zeitmangel entfallen lassen. |
| 7 | 07 | **Parametername:** In Samba 4.19.5 zeigte `testparm` `server smb encrypt`; `smb encrypt` wurde im Lauf nicht angezeigt. Das Verhalten älterer Versionen wurde nicht geprüft. | Namen für die eingesetzte Version prüfen. |
| 8 | 08 | **Meldungen:** Falsches Passwort und unbekannter Benutzer lieferten dieselbe Meldung; das Server-Log wurde mit Log-Stufe 1 nicht ausgewertet. | Mit höherer Log-Stufe auf `fs01` untersuchen. |
