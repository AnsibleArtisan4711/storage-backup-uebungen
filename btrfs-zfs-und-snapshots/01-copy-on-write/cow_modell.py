#!/usr/bin/env python3
"""Modell: Überschreiben an Ort und Stelle gegen Copy-on-Write (CoW).
Ein „Dateisystem“ speichert drei Blöcke einer Datei. Eine Änderung braucht zwei Teilschritte; mitten drin fällt der Strom aus.
Vereinfachtes Modell mit erfundenen Daten, keine Messung. Aufruf: python3 cow_modell.py"""

class InPlace:
    """Bloecke werden direkt ueberschrieben."""
    def __init__(self):
        self.bloecke = {0: 'A1', 1: 'B1', 2: 'C1'}
    def schreibe(self, aenderungen, absturz_nach=None):
        for i, (nr, wert) in enumerate(aenderungen):
            self.bloecke[nr] = wert
            if absturz_nach is not None and i + 1 == absturz_nach:
                raise RuntimeError('Absturz')
    def zustand(self):
        return [self.bloecke[i] for i in range(3)]

class CoW:
    """Neue Blöcke werden an freien Stellen geschrieben; erst am Ende zeigt die Wurzel (root) auf die neue Fassung."""
    def __init__(self):
        self.speicher = {10: 'A1', 11: 'B1', 12: 'C1'}   # physische Blöcke
        self.root = [10, 11, 12]                          # Wurzel: welche Blöcke bilden die Datei?
        self.frei = 20
    def schreibe(self, aenderungen, absturz_nach=None):
        neu = list(self.root)
        for i, (nr, wert) in enumerate(aenderungen):
            self.speicher[self.frei] = wert; neu[nr] = self.frei; self.frei += 1
            if absturz_nach is not None and i + 1 == absturz_nach:
                raise RuntimeError('Absturz')
        self.root = neu                                   # atomarer Schritt: Wurzel umschalten
    def zustand(self):
        return [self.speicher[b] for b in self.root]
    def snapshot(self):
        return list(self.root)                            # Snapshot = alte Wurzel merken, ohne Daten zu kopieren

def versuch(klasse, absturz_nach):
    fs = klasse()
    vorher = fs.zustand()
    try:
        fs.schreibe([(0, 'A2'), (2, 'C2')], absturz_nach)
    except RuntimeError:
        pass
    return vorher, fs.zustand()

if __name__ == '__main__':
    print('Zwei zusammengehörende Änderungen: Block 0 -> A2 und Block 2 -> C2 (gedacht als eine Einheit)')
    for name, klasse in (('Überschreiben', InPlace), ('Copy-on-Write', CoW)):
        for stufe, text in ((None, 'ohne Absturz'), (1, 'Absturz nach dem ersten Block')):
            v, n = versuch(klasse, stufe)
            konsistent = n in (v, ['A2', 'B1', 'C2'])
            print(f'  {name:14} {text:30} vorher={v} nachher={n} -> {"konsistent" if konsistent else "INKONSISTENT (halb geändert)"}')
    print()
    fs = CoW(); alt = fs.snapshot(); fs.schreibe([(0, 'A2')])
    gemeinsam = set(alt) & set(fs.root)
    print(f'Snapshot: alte Wurzel {alt}, neue Wurzel {fs.root}; gemeinsame physische Blöcke: {sorted(gemeinsam)} ({len(gemeinsam)} von 3)')
    print('Alter Stand über den Snapshot:', [fs.speicher[b] for b in alt], '  aktueller Stand:', fs.zustand())
