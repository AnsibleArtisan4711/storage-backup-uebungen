#!/usr/bin/env python3
"""iSCSI-Namen auf das übliche Format prüfen: iqn.JJJJ-MM.umgekehrte-domain[:beliebiger-text] oder eui.16-Hex.
Die Formatregeln stammen aus Fachwissen; der RFC wurde NICHT gelesen. Kleinschreibung der Domain wird hier als Empfehlung gemeldet."""
import re, sys
def pruefe(n):
    if re.fullmatch(r'eui\.[0-9A-Fa-f]{16}', n): return 'ok (eui-Format)'
    m = re.fullmatch(r'iqn\.(\d{4})-(\d{2})\.([^:]+)(?::(.+))?', n)
    if not m: return 'ungültig: weder iqn.JJJJ-MM.domain[:text] noch eui.16-Hex'
    j, mo, dom, rest = m.groups()
    if not 1 <= int(mo) <= 12: return f'ungültig: Monat {mo}'
    if not re.fullmatch(r'[A-Za-z0-9.-]+', dom) or '.' not in dom: return 'ungültig: Domain-Teil (mindestens zwei Teile, nur Buchstaben, Ziffern, Punkt, Bindestrich)'
    hinweis = ' (Empfehlung: Domain klein schreiben)' if dom != dom.lower() else ''
    return 'ok' + (' mit Zusatzteil' if rest else ' ohne Zusatzteil') + hinweis
for n in sys.argv[1:]: print(f"{n:48} {pruefe(n)}")
