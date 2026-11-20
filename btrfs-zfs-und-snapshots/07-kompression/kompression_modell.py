#!/usr/bin/env python3
"""Wann lohnt sich Kompression? Misst mit zlib (Python-Standardbibliothek) und erfundenen Testdaten (fester Startwert).
Es ist NICHT dasselbe Verfahren wie zstd/lzo im Dateisystem; es zeigt nur, dass der Nutzen von den Daten abhängt. Aufruf: python3 kompression_modell.py"""
import random, zlib, time

def daten():
    r = random.Random(1)
    woerter = [''.join(r.choice('abcdefghiklmnoprstuw') for _ in range(r.randint(3, 9))) for _ in range(800)]
    text = ' '.join(r.choice(woerter) for _ in range(150000)).encode()
    zufall = bytes(r.randrange(256) for _ in range(len(text)))
    nullen = bytes(len(text))
    schon = zlib.compress(text, 9)                      # bereits komprimierte Daten (wie .zip, .jpg, .mp4)
    return {'Text (Wörter)': text, 'Zufall (z. B. verschlüsselt)': zufall, 'nur Nullen': nullen, 'bereits komprimiert': schon * 3}

if __name__ == '__main__':
    print(f'{"Daten":32}{"Größe":>10}{"zlib -1":>10}{"zlib -6":>10}{"Zeit -6":>10}')
    for name, d in daten().items():
        t0 = time.perf_counter(); c6 = zlib.compress(d, 6); t = time.perf_counter() - t0
        c1 = zlib.compress(d, 1)
        print(f'{name:32}{len(d):>10}{100*len(c1)/len(d):>9.1f}%{100*len(c6)/len(d):>9.1f}%{t*1000:>8.0f} ms')
    print('(Anteil der komprimierten Größe an der Originalgröße; die Zeiten sind Messwerte dieses Laufs und variieren.)')
