# 07 iSCSI-Initiator

Übung **07.1** (Priorität 1). Geschätzte Zeit: 7 bis 9 Stunden (Schätzung; Lehrplan: 12 UE zu 45 Minuten = 9 Stunden).

> Skript im Container (libiscsi, Userspace) ausgeführt.

| Datei | Zweck |
|---|---|
| `07.1-iscsi-initiator.md` | Die Übung mit Aufgaben, Kontrollfragen und Musterlösung |
| `initiator_lesen.sh` | iSCSI-Initiator mit den libiscsi-Werkzeugen (Userspace, ohne Kernel-Initiator): entdecken, abfragen, Zugriffsschutz prüfen |
| `iqn_pruefen.py` | iSCSI-Namen auf das übliche Format prüfen: iqn.JJJJ-MM.umgekehrte-domain[:beliebiger-text] oder eui.16-Hex. |
| `beispiele/initiator_lesen.ausgabe.txt` | Echte Ausgabe des Laufs von `initiator_lesen` |
