#!/usr/bin/env python3
"""Modell: Warum Prüfsummen schleichende Datenfehler („Bit-Rot“) erkennen und mit einer zweiten Kopie reparieren können.
Echte CRC-32-Berechnung (Python zlib), aber erfundene Blöcke; kein Dateisystem. Aufruf: python3 pruefsumme_modell.py"""
import zlib, random

BLOCK = 4096

def pruefsumme(b):
    return zlib.crc32(b) & 0xffffffff

class Speicher:
    def __init__(self, kopien):
        self.kopien = [dict() for _ in range(kopien)]     # je Kopie: Blocknr -> Bytes
        self.summen = {}                                  # Prüfsummen liegen getrennt von den Daten (im Elternknoten)
    def schreibe(self, nr, daten):
        for k in self.kopien: k[nr] = daten
        self.summen[nr] = pruefsumme(daten)
    def lies(self, nr):
        for i, k in enumerate(self.kopien):
            if pruefsumme(k[nr]) == self.summen[nr]:
                if i > 0:
                    self.kopien[0][nr] = k[nr]               # Selbstheilung: gute Kopie überschreibt die schlechte
                    return k[nr], f'repariert aus Kopie {i + 1}'
                return k[nr], 'ok'
        return None, 'FEHLER: alle Kopien beschädigt (erkannt, nicht reparierbar)'

def kippe_bit(daten, seed):
    r = random.Random(seed); b = bytearray(daten); pos = r.randrange(len(b)); b[pos] ^= 1 << r.randrange(8)
    return bytes(b)

if __name__ == '__main__':
    rnd = random.Random(1)
    original = bytes(rnd.randrange(256) for _ in range(BLOCK))
    for kopien, name in ((1, 'eine Kopie (single)'), (2, 'zwei Kopien (Spiegel)')):
        s = Speicher(kopien)
        s.schreibe(0, original)
        s.kopien[0][0] = kippe_bit(original, 7)             # ein Bit in Kopie 1 kippt
        daten, status = s.lies(0)
        print(f'{name:24}: Lesen -> {status}; Daten stimmen: {daten == original}')
    print()
    print('Ohne Prüfsumme (klassisches Dateisystem) würde der Block mit dem gekippten Bit unbemerkt als gültig gelesen:')
    d = kippe_bit(original, 7)
    print(f'  Bytes verschieden: {sum(1 for a, b in zip(original, d) if a != b)} von {BLOCK}; Prüfsumme alt {pruefsumme(original):08x}, neu {pruefsumme(d):08x}')
