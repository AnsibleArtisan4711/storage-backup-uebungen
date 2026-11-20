#!/usr/bin/env python3
"""Freigabe-Konfigurationen auf riskante Muster prüfen (reine Textprüfung, ohne Server).
Eingabe: eine NFS-Datei im Format von /etc/exports und eine Samba-Konfiguration (smb.conf).
Die Regeln stammen aus Fachwissen; die Dokumentation von NFS und Samba wurde NICHT gelesen und die Server nicht ausgeführt."""
import sys, re

def pruefe_exports(pfad):
    hinweise = []
    for nr, z in enumerate(open(pfad, encoding='utf-8'), 1):
        z = z.split('#')[0].strip()
        if not z: continue
        teile = z.split()
        verz, clients = teile[0], teile[1:]
        if not clients: hinweise.append((nr, verz, 'kein Client angegeben')); continue
        for c in clients:
            m = re.match(r'([^()]*)\(([^)]*)\)$', c)
            host, opt = (m.group(1), m.group(2).split(',')) if m else (c, [])
            if host in ('*', '') : hinweise.append((nr, verz, f'für alle Clients freigegeben ({c})'))
            if 'rw' in opt and host in ('*', ''): hinweise.append((nr, verz, 'schreibbar für alle Clients'))
            if 'no_root_squash' in opt: hinweise.append((nr, verz, f'no_root_squash für {host or "alle"}: root des Clients ist root auf dem Server'))
            if 'async' in opt: hinweise.append((nr, verz, f'async für {host or "alle"}: Daten können bei Absturz verloren gehen'))
            if 'insecure' in opt: hinweise.append((nr, verz, f'insecure für {host or "alle"}: Quellports über 1024 erlaubt'))
            if not ({'rw', 'ro'} & set(opt)) and m: hinweise.append((nr, verz, f'weder ro noch rw für {host}: Standard prüfen'))
    return hinweise

def pruefe_smb(pfad):
    hinweise, sektion = [], None
    for nr, z in enumerate(open(pfad, encoding='utf-8'), 1):
        z = z.split('#')[0].split(';')[0].strip()
        if not z: continue
        m = re.match(r'\[(.+)\]$', z)
        if m: sektion = m.group(1); continue
        if '=' not in z: continue
        k, v = [x.strip().lower() for x in z.split('=', 1)]
        if k == 'guest ok' and v in ('yes', 'true'): hinweise.append((nr, sektion, 'Gastzugriff erlaubt'))
        if k in ('writable', 'writeable') and v in ('yes', 'true') or (k == 'read only' and v in ('no', 'false')):
            hinweise.append((nr, sektion, 'schreibbar (prüfen, wer schreiben darf)'))
        if k == 'server min protocol' and v in ('nt1', 'lanman1', 'lanman2', 'core', 'coreplus'):
            hinweise.append((nr, sektion, f'veraltetes Protokoll erlaubt ({v})'))
        if k == 'map to guest' and v != 'never': hinweise.append((nr, sektion, f'map to guest = {v}: unbekannte Benutzer werden als Gast angemeldet'))
        if k == 'security' and v == 'share': hinweise.append((nr, sektion, 'security = share: veraltete Betriebsart'))
    return hinweise

for f, fn in (('beispiel_exports', pruefe_exports), ('beispiel_smb.conf', pruefe_smb)):
    print(f"Datei: {f}")
    h = fn(f)
    for nr, ort, t in h: print(f"  Zeile {nr:<3} {ort:12} {t}")
    print(f"  -> {len(h)} Hinweis(e)\n")
