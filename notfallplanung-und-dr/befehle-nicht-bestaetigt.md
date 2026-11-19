# Befehle und Aussagen, die nicht bestätigt sind

Prüfliste für den ersten Durchlauf: Befund und Datum eintragen, danach den Hinweis in der Übung entfernen. Legende: **Q** = gegen Quelle gelesen; **L** = im Labor (Container) ausgeführt; **–** = weder noch.

| Modul | Befehl oder Aussage | Status | Nächster Schritt |
|---|---|---|---|
| alle | Aufbau des Hyper-V-Labors, Internetphase | – | laut Lehrplan aufbauen und prüfen |
| 01 | Begriffe (Notfall, Krise, Business Continuity, Disaster Recovery) und Phasen des Notfallmanagements; Normen (ISO 22301, BSI-Standard 200-4) nicht gelesen | – | gegen die Normen bzw. den BSI-Standard prüfen |
| 02 | `bia.py`, Klassengrenzen und Schadensformel | L (Python 3.13) | Annahmen mit Fachbereichen abstimmen |
| 03 | `risiko.py`, Skalen und Schwellen (15 / 8) | L | Schwellen mit Risikomanagement abstimmen |
| 04 | `wiederanlauf.py` (graphlib, Helferzahl) | L | Dauern durch Messung ersetzen |
| 05 | `standortvergleich.py`; alle Kosten und Zeiten | L, Werte erfunden | echte Angebote einsetzen |
| 06 | `alarmkette.py`; 5 Minuten je Versuch | L, Annahme | mit einer echten Übung vergleichen |
| 07 | `restore_zeit.sh` (restic, bc), Messwerte | L (restic 0.16.4) | auf echter Hardware messen; mit Debian-12-Version wiederholen |
| 08 | `wbadmin start recovery`, `start systemstaterecovery` (`-authsysvol`), `start sysrecovery` (`-recreateDisks`) | Q (Microsoft Learn), nicht ausgeführt | im Lab mit Prüfpunkt ausführen |
| 08 | Ablauf der autoritativen Wiederherstellung (Active Directory), Rolle von `ntdsutil` | – (Fachwissen) | gegen Microsoft Learn prüfen |
| 09 | `handbuch_pruefen.py`, Pflichtabschnitte und 12-Monats-Stand | L | mit betrieblichen Vorgaben abgleichen |
| 10 | `uebung_protokoll.py`, Toleranz 20 Prozent | L | mit echten Übungen abgleichen |
| 11 | `massnahmen.py` | L | – |
| 12 | `szenario_entscheid.py` (Übungsmodell), Vorgehen bei Angriff (Eindämmen, Beweise, Wiederherstellung) | L, Modell | mit IT-Forensik und Rechtsberatung abstimmen; Meldefristen prüfen |
| 13 | `dr_gesamtcheck.py` | L | – |
