#!/usr/bin/env python3
"""Multipath als Modell: zwei Pfade zum selben Speicher, Verteilung der Zugriffe und Ausfall eines Pfades.
Es wird KEIN echtes Multipath verwendet (kein device-mapper im Testlabor); Richtlinien-Namen sind Fachwissen und nicht bestätigt."""
import itertools

def lauf(politik, ausfall_ab=None, anzahl=12):
    pfade = {'pfad-A': True, 'pfad-B': True}
    namen = list(pfade)
    rr = itertools.cycle(namen)
    zaehler = {n: 0 for n in namen}
    aktiv = 'pfad-A'
    protokoll = []
    for i in range(1, anzahl + 1):
        if ausfall_ab and i == ausfall_ab:
            pfade['pfad-A'] = False; protokoll.append(f"  E/A {i:>2}: >>> pfad-A fällt aus <<<")
        if politik == 'aktiv/passiv':
            if not pfade[aktiv]:
                aktiv = next(n for n in namen if pfade[n]); protokoll.append(f"  E/A {i:>2}: Umschaltung auf {aktiv}")
            ziel = aktiv
        else:   # Round Robin über alle intakten Pfade
            ziel = next(n for n in rr if pfade[n]) if any(pfade.values()) else None
        zaehler[ziel] += 1
    return zaehler, protokoll

for politik in ('aktiv/passiv', 'round-robin'):
    for ausfall in (None, 7):
        z, p = lauf(politik, ausfall)
        titel = f"{politik}, " + ("alle Pfade intakt" if not ausfall else f"pfad-A fällt vor E/A {ausfall} aus")
        print(titel)
        for zeile in p: print(zeile)
        print("  Verteilung:", z)
print("\nModell-Aussage: Mit Multipath bleibt der Speicher erreichbar, solange mindestens ein Pfad lebt; ohne Multipath würde jede")
print("E/A nach dem Ausfall des Pfades scheitern oder das Gerät verschwinden. Echtes Verhalten (Zeitüberschreitungen, Umschaltzeit) ist nicht modelliert.")
