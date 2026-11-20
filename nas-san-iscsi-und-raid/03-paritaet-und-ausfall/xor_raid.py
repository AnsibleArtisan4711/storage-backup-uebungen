#!/usr/bin/env python3
"""RAID-5-Prinzip mit XOR nachgebildet (Modell in Python, kein echtes md-RAID).
Daten werden in Streifen auf drei Platten verteilt, die vierte Position je Streifen trägt die Parität.
Bei Ausfall einer Platte wird ihr Inhalt aus den übrigen berechnet. Am Ende: das „Write Hole“."""
N = 4            # Platten
CH = 4           # Bytes je Chunk
text = b"RAID-Paritaet mit XOR zeigt, wie ein Ausfall berechnet wird."
text += b"." * (-len(text) % (CH * (N - 1)))

def xor(*bl):
    r = bytearray(CH)
    for b in bl:
        for i in range(CH): r[i] ^= b[i]
    return bytes(r)

platten = [[] for _ in range(N)]
paritaet_pos = []
chunks = [text[i:i+CH] for i in range(0, len(text), CH)]
for s in range(len(chunks) // (N - 1)):
    pp = (N - 1 - s) % N                      # Parität wandert von Streifen zu Streifen
    paritaet_pos.append(pp)
    daten = chunks[s*(N-1):(s+1)*(N-1)]
    di = 0
    for p in range(N):
        if p == pp: platten[p].append(xor(*daten))
        else: platten[p].append(daten[di]); di += 1
print(f"{len(chunks)//(N-1)} Streifen, {N} Platten, Chunk {CH} Bytes. Parität je Streifen auf Platte: {paritaet_pos}")
print("Streifen 0 (hex):", [platten[p][0].hex() for p in range(N)], "-> Parität auf Platte", paritaet_pos[0])

def lesen(platten, ausgefallen=None):
    """Liest den Text; fehlt eine Platte, wird jeder Chunk aus den übrigen drei per XOR rekonstruiert."""
    aus = b""
    for s in range(len(platten[0])):
        pp = paritaet_pos[s]
        reihe = []
        for p in range(N):
            if p == ausgefallen:
                rest = [platten[q][s] for q in range(N) if q != p]
                reihe.append(xor(*rest))
            else: reihe.append(platten[p][s])
        aus += b"".join(reihe[p] for p in range(N) if p != pp)
    return aus

print("\nLesen ohne Ausfall:      ", lesen(platten).rstrip(b".").decode())
for ausfall in range(N):
    ok = lesen(platten, ausfall) == text
    print(f"Platte {ausfall} ausgefallen -> rekonstruiert: {'ja, identisch' if ok else 'NEIN'}")

print("\n## Zwei Ausfälle: nicht rekonstruierbar (RAID 5 verkraftet nur eine Platte)")
def zwei_ausfaelle(a, b):
    s = 0; pp = paritaet_pos[s]
    # Von zwei fehlenden Chunks bleibt nur eine Gleichung: XOR(a)^XOR(b) ist bekannt, die Einzelwerte nicht.
    rest = [platten[q][s] for q in range(N) if q not in (a, b)]
    return xor(*rest)
print("Platten 0 und 1 fehlen: bekannt ist nur die XOR-Summe der beiden fehlenden Chunks:", zwei_ausfaelle(0, 1).hex(), "-> Einzelwerte nicht eindeutig")

print("\n## Write Hole: Daten geschrieben, Parität noch nicht (Stromausfall mitten im Schreibvorgang)")
import copy
p2 = copy.deepcopy(platten)
s = 0; pp = paritaet_pos[s]
ziel = 1 if pp != 1 else 2
alt = p2[ziel][s]
p2[ziel][s] = b"NEUE"                          # Datenchunk ist neu, Paritätschunk noch alt
print(f"Platte {ziel}: Chunk {alt!r} -> b'NEUE', Parität unverändert")
ausfall = 0 if ziel != 0 else 3
rek = lesen(p2, ausfall)
print(f"Danach fällt Platte {ausfall} aus. Rekonstruktion identisch zum Soll? {'ja' if rek.replace(b'NEUE', alt)==text else 'NEIN'}")
print("Der rekonstruierte Chunk der ausgefallenen Platte ist falsch, ohne dass es ein Fehlersignal gibt.")
print("Gegenmittel (Fachwissen, hier nicht ausgeführt): Journal, batteriegepufferter Cache, USV.")
