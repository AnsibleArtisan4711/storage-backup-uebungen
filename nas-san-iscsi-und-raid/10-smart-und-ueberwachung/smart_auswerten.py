#!/usr/bin/env python3
"""SMART-Attribute aus einer Textdatei im Format von `smartctl -A` auswerten (die Beispieldateien sind ERFUNDEN).
Die Hinweisregeln (welche Attribute wichtig sind) sind Fachwissen und nicht bestätigt; die Grenzen sind Annahmen."""
import sys, re
KRITISCH = {5: 'Reallocated_Sector_Ct (neu zugewiesene Sektoren)', 187: 'Reported_Uncorrect (nicht korrigierbare Fehler)',
            197: 'Current_Pending_Sector (Sektoren warten auf Neuzuweisung)', 198: 'Offline_Uncorrectable (offline nicht korrigierbar)'}
BEOBACHTEN = {188: 'Command_Timeout', 199: 'UDMA_CRC_Error_Count (oft Kabel oder Anschluss)'}

def auswerten(pfad):
    hinweise = []
    for z in open(pfad, encoding='utf-8'):
        m = re.match(r'\s*(\d+)\s+(\S+)\s+0x\w+\s+(\d+)\s+(\d+)\s+(\d+)\s+\S+\s+\S+\s+(\S+)\s+(\d+)', z)
        if not m: continue
        id_, name, wert, schlecht, grenze, wann, roh = int(m[1]), m[2], int(m[3]), int(m[4]), int(m[5]), m[6], int(m[7])
        if wann != '-': hinweise.append(f"{id_:>3} {name}: SMART meldet Ausfall ({wann})")
        elif grenze and schlecht <= grenze: hinweise.append(f"{id_:>3} {name}: schlechtester Wert {schlecht} erreichte die Grenze {grenze}")
        if id_ in KRITISCH and roh > 0: hinweise.append(f"{id_:>3} {name}: Rohwert {roh} > 0 -> {KRITISCH[id_]}: Platte beobachten, Ersatz planen")
        if id_ in BEOBACHTEN and roh > 0: hinweise.append(f"{id_:>3} {name}: Rohwert {roh} > 0 -> {BEOBACHTEN[id_]}: beobachten")
        if id_ == 194 and roh > 50: hinweise.append(f"{id_:>3} {name}: {roh} Grad (Annahme: über 50 Grad ist hoch)")
    return hinweise

for p in sys.argv[1:]:
    h = auswerten(p)
    print(f"Datei: {p}")
    for t in h: print("  " + t)
    print(f"  -> {len(h)} Hinweis(e)" + ("" if h else " (unauffällig)") + "\n")
