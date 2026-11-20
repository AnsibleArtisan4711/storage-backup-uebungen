#!/usr/bin/env python3
"""RAID-Stufen vergleichen: nutzbare Kapazität, Ausfalltoleranz, Schreibaufwand, Rebuild-Risiko.
Die Formeln für Kapazität und Toleranz sind Standardwissen; der Wert für Lesefehler (URE) ist eine ANNAHME
(Herstellerangaben unterscheiden sich) und das Rebuild-Risiko ist nur eine grobe Abschätzung."""
import sys

def raid(stufe, n, gb):
    """Gibt (nutzbar_gb, toleranz_text, schreib_io) oder None zurück, wenn die Platten nicht reichen."""
    if stufe == 0 and n >= 2:  return (n * gb, "keine", 1)
    if stufe == 1 and n >= 2:  return (gb, f"{n-1} Platte(n)", n)       # Spiegel über alle n Platten
    if stufe == 5 and n >= 3:  return ((n - 1) * gb, "1 Platte", 4)
    if stufe == 6 and n >= 4:  return ((n - 2) * gb, "2 Platten", 6)
    if stufe == 10 and n >= 4 and n % 2 == 0: return (n // 2 * gb, "1 je Spiegelpaar (mind. 1)", 2)
    return None

def ure_risiko(platten_gelesen, gb, ure_je_bit):
    """Wahrscheinlichkeit, dass beim Rebuild mindestens ein nicht lesbares Bit auftritt (Annahme: unabhängige Fehler)."""
    bits = platten_gelesen * gb * 1e9 * 8
    return 1 - (1 - ure_je_bit) ** bits

n = int(sys.argv[1]) if len(sys.argv) > 1 else 4
gb = int(sys.argv[2]) if len(sys.argv) > 2 else 8000
ure = float(sys.argv[3]) if len(sys.argv) > 3 else 1e-14
print(f"{n} Platten zu je {gb} GB (Annahme URE-Rate {ure:g} je gelesenes Bit)")
print(f"{'Stufe':8} {'nutzbar GB':>11} {'Anteil':>7}  {'Ausfall verkraftet':28} {'Schreib-I/O*':>12}")
for s in (0, 1, 5, 6, 10):
    r = raid(s, n, gb)
    if r is None:
        print(f"RAID {s:<3} nicht möglich mit {n} Platten"); continue
    nutz, tol, io = r
    print(f"RAID {s:<3} {nutz:>11} {nutz/(n*gb):>6.0%}  {tol:28} {io:>12}")
print("* theoretische Platten-I/Os je kleinem Schreibvorgang (read-modify-write); reale Werte hängen von Cache und Controller ab")
print()
print("Rebuild-Risiko nach Ausfall einer Platte (Lesen aller verbleibenden Platten):")
for s in (5, 6):
    if raid(s, n, gb):
        p = ure_risiko(n - 1, gb, ure)
        print(f"  RAID {s}: {n-1} Platten lesen = {(n-1)*gb/1000:.0f} TB -> Wahrscheinlichkeit mindestens eines Lesefehlers rund {p:.0%}"
              + ("  (RAID 6 hat noch Paritätsreserve)" if s == 6 else "  (keine Reserve mehr)"))
print("Hinweis: Das ist ein Modell mit angenommener Fehlerrate, keine Vorhersage für ein bestimmtes Laufwerk.")
