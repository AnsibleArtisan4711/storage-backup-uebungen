#!/usr/bin/env python3
"""Modell (NICHT ZFS selbst): Pool, vdevs, Datasets und vererbte Eigenschaften nach dem ZFS-Aufbau (Fachwissen, nicht bestätigt).
Es werden keine Platten verwendet; Namen, Größen und Eigenschaften sind erfunden. Aufruf: python3 zfs_modell.py"""
from dataclasses import dataclass, field

@dataclass
class Vdev:
    art: str            # 'mirror', 'raidz1', 'raidz2', 'single'
    platten: list
    groesse_gb: int = 100   # Größe je Platte (Annahme)
    def nutzbar(self):
        n = len(self.platten)
        return {'single': self.groesse_gb, 'mirror': self.groesse_gb,
                'raidz1': (n - 1) * self.groesse_gb, 'raidz2': (n - 2) * self.groesse_gb}[self.art]
    def ausfall_toleranz(self):
        return {'single': 0, 'mirror': len(self.platten) - 1, 'raidz1': 1, 'raidz2': 2}[self.art]

@dataclass
class Dataset:
    name: str
    props: dict = field(default_factory=dict)       # lokal gesetzte Eigenschaften
    eltern: 'Dataset' = None
    def hole(self, schluessel, default='-'):
        d = self
        while d is not None:
            if schluessel in d.props:
                herkunft = 'lokal' if d is self else f'geerbt von {d.name}'
                return d.props[schluessel], herkunft
            d = d.eltern
        return default, 'Standard'

@dataclass
class Pool:
    name: str
    vdevs: list
    def kapazitaet(self):
        return sum(v.nutzbar() for v in self.vdevs)
    def toleranz(self):
        # Fällt ein ganzes vdev aus, ist der Pool verloren: es zählt das schwächste vdev
        return min(v.ausfall_toleranz() for v in self.vdevs)

if __name__ == '__main__':
    pool = Pool('tank', [Vdev('mirror', ['sdb', 'sdc']), Vdev('mirror', ['sdd', 'sde'])])
    print(f'Pool {pool.name}: {len(pool.vdevs)} vdevs, nutzbar {pool.kapazitaet()} GB, Ausfalltoleranz je vdev {pool.toleranz()} Platte(n)')
    p2 = Pool('archiv', [Vdev('raidz2', ['sdf', 'sdg', 'sdh', 'sdi'])])
    print(f'Pool {p2.name}: {len(p2.vdevs)} vdev, nutzbar {p2.kapazitaet()} GB, Ausfalltoleranz {p2.toleranz()} Platte(n)')
    wurzel = Dataset('tank', {'compression': 'lz4'})
    daten = Dataset('tank/daten', {}, wurzel)
    vm = Dataset('tank/daten/vm', {'compression': 'off', 'recordsize': '16K'}, daten)
    print('\nVererbung von Eigenschaften:')
    for d in (wurzel, daten, vm):
        for k in ('compression', 'recordsize'):
            wert, herk = d.hole(k)
            print(f'  {d.name:14} {k:12} = {wert:5} ({herk})')
