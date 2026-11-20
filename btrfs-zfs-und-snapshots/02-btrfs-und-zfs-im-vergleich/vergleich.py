#!/usr/bin/env python3
"""Vergleichstabelle Btrfs und ZFS. Spalte „Status“: L = die Btrfs-Aussage wurde in diesem Material im Labor-Container geprüft;
F = Fachwissen, NICHT bestätigt (ZFS wurde im Container nicht ausgeführt, die Dokumentation wurde nicht gelesen).
Aufruf: python3 vergleich.py [SCHLÜSSELWORT]  (filtert Zeilen)"""
import sys

ZEILEN = [
    # Merkmal, Btrfs, ZFS, Status
    ('Verwaltungsmodell', 'Dateisystem mit Subvolumes (`btrfs subvolume`)', 'Pool (`zpool`) mit Datasets (`zfs`)', 'Btrfs L, ZFS F'),
    ('Copy-on-Write', 'ja (Reflinks, Snapshots)', 'ja', 'Btrfs L, ZFS F'),
    ('Prüfsummen für Daten und Metadaten', 'ja, Standard crc32c (laut `dump-super`), weitere Verfahren wählbar', 'ja, Standard fletcher4, weitere Verfahren wählbar', 'Btrfs L (Standard), ZFS F'),
    ('Selbstheilung bei Redundanz', 'ja, Scrub repariert aus der Kopie (raid1)', 'ja, Scrub/Lesen repariert aus Spiegel oder Parität', 'Btrfs L, ZFS F'),
    ('Snapshots', 'Subvolume-Snapshots, schreibgeschützt oder beschreibbar', 'Snapshots (schreibgeschützt), Klone (beschreibbar)', 'Btrfs L, ZFS F'),
    ('Replikation', '`btrfs send` / `btrfs receive`, inkrementell mit Elternsnapshot', '`zfs send` / `zfs receive`, inkrementell', 'Btrfs L, ZFS F'),
    ('Kompression', 'zstd, zlib, lzo (Mount-Option oder Eigenschaft)', 'lz4, zstd, gzip (Eigenschaft je Dataset)', 'Btrfs L, ZFS F'),
    ('Redundanz-Profile', 'single, dup, raid0, raid1, raid10 (raid5/6 mit Einschränkungen laut Fachwissen)', 'Stripe, Spiegel, raidz1/2/3', 'Btrfs L (raid1), Rest F'),
    ('Quoten', 'qgroups (`btrfs quota`)', 'quota, refquota, reservation je Dataset', 'Btrfs L, ZFS F'),
    ('Einbindung in Linux', 'Teil des Kernels (GPL)', 'OpenZFS, separates Kernelmodul, Lizenz CDDL', 'F'),
    ('Arbeitsspeicher', 'nutzt den normalen Seitencache', 'eigener Cache (ARC), Speicherbedarf beachten', 'F'),
]

def zeige(filter_=None):
    n = 0
    for m, b, z, s in ZEILEN:
        if filter_ and filter_.lower() not in (m + b + z).lower():
            continue
        print(f'{m}\n   Btrfs: {b}\n   ZFS:   {z}\n   Status: {s}'); n += 1
    print(f'{n} Zeile(n)')

if __name__ == '__main__':
    zeige(sys.argv[1] if len(sys.argv) > 1 else None)
