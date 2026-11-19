#!/usr/bin/env python3
"""Entscheidungshilfe Cyberangriff (Übungsmodell, keine Einsatzvorschrift): welche Reihenfolge der Schritte ergibt sich aus dem Lagebild?
Aufruf: python3 szenario_entscheid.py <aktiv|abgeschlossen> <backup_sauber|backup_unklar|backup_verschluesselt> <ad_betroffen|ad_ok>
Die Regeln sind bewusst einfach und bilden das Vorgehen der Übung ab: erst eindämmen, dann sichern (Beweise), dann sauber neu aufbauen."""
import sys
if len(sys.argv) != 4: sys.exit(__doc__)
angriff, backup, ad = sys.argv[1:4]
s = []
if angriff == "aktiv": s += ["Betroffene Systeme vom Netz trennen (Netzwerk-Port/VLAN sperren), Ausschalten nur nach Absprache (flüchtige Spuren gehen verloren; Vorgehen mit IT-Forensik/Rechtsberatung klären)"]
s += ["Entscheidungsträger und Datenschutzbeauftragte informieren (Meldefristen prüfen lassen, Rechtsberatung einbeziehen)",
      "Beweissicherung: Logs und Abbilder der betroffenen Systeme auf getrenntes Medium kopieren"]
if backup == "backup_sauber": s += ["Backup-Zeitpunkt vor dem Angriff bestimmen (Logs, Eintrittszeit), Restore in isoliertes Netz testen"]
elif backup == "backup_unklar": s += ["Backups schreibgeschützt halten, Prüfung auf Befall im isolierten Netz, ältere Stände heranziehen"]
else: s += ["Backups gelten als verloren, Offline-/Offsite-Kopien suchen (3-2-1-1-0), sonst Neuaufbau mit Datenverlust und Rechtsberatung"]
if ad == "ad_betroffen": s += ["Active Directory als kompromittiert behandeln: sauberen Neuaufbau planen, alle Kennwörter und Dienstkonten erneuern"]
s += ["Systeme in der Wiederanlauf-Reihenfolge (Modul 04) sauber neu aufbauen, nicht betroffene Systeme vor der Wiederinbetriebnahme auf Befall prüfen", "Erst nach Freigabe und Überwachungsphase den Normalbetrieb melden", "Lessons Learned und Maßnahmenverfolgung (Modul 11)"]
print("Lagebild: Angriff=%s, Backup=%s, AD=%s\n" % (angriff, backup, ad))
for i, t in enumerate(s, 1): print("%d. %s" % (i, t))
