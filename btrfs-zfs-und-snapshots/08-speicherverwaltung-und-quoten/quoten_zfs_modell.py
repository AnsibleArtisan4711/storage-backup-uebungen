#!/usr/bin/env python3
"""Modell (NICHT ZFS selbst): quota, refquota und reservation nach dem ZFS-Prinzip (Fachwissen, nicht bestätigt).
quota: Grenze für Dataset samt Kindern und Snapshots; refquota: nur für die eigenen Daten (ohne Snapshots und Kinder);
reservation: garantierter Platz. Erfundene Größen in GB. Aufruf: python3 quoten_zfs_modell.py"""

def pruefe(name, daten_gb, snapshots_gb, kinder_gb, quota=None, refquota=None):
    belegung = daten_gb + snapshots_gb + kinder_gb
    meldungen = []
    if refquota is not None and daten_gb > refquota:
        meldungen.append(f'refquota {refquota} GB überschritten (eigene Daten {daten_gb} GB)')
    if quota is not None and belegung > quota:
        meldungen.append(f'quota {quota} GB überschritten (Daten + Snapshots + Kinder = {belegung} GB)')
    status = 'Schreiben abgelehnt: ' + '; '.join(meldungen) if meldungen else 'Schreiben möglich'
    print(f'  {name:28} Daten {daten_gb:3} + Snapshots {snapshots_gb:3} + Kinder {kinder_gb:3} = {belegung:3} GB -> {status}')

if __name__ == '__main__':
    print('Fall 1: nur quota 100 GB: Snapshots zählen mit')
    pruefe('tank/projekt (80 GB)', 80, 0, 0, quota=100)
    pruefe('tank/projekt (80, Snap 30)', 80, 30, 0, quota=100)
    print('Fall 2: refquota 100 GB: Snapshots zählen nicht')
    pruefe('tank/projekt (80, Snap 30)', 80, 30, 0, refquota=100)
    pruefe('tank/projekt (105, Snap 0)', 105, 0, 0, refquota=100)
    print('Fall 3: Kinder-Datasets zählen bei quota mit')
    pruefe('tank/abteilung', 10, 5, 90, quota=100)
    print('Reservation: garantierter Platz je Dataset; Summe der Reservierungen darf den Pool nicht übersteigen')
    pool_gb, res = 500, {'tank/db': 200, 'tank/vm': 200, 'tank/daten': 150}
    summe = sum(res.values())
    print(f'  Pool {pool_gb} GB, Reservierungen {res} = {summe} GB -> {"nicht möglich" if summe > pool_gb else "möglich"}')
