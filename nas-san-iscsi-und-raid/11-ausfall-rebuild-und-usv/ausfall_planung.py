#!/usr/bin/env python3
"""Ausfall und Wiederherstellung rechnen: Rebuild-Zeit und Risikofenster, USV-Laufzeit für sauberes Herunterfahren.
Alle Eingaben sind ANNAHMEN; die Rechnungen sind einfache Modelle ohne Rücksicht auf Cache, Last und Alterung."""
def rebuild(gb, mb_s, last_anteil):
    """Dauer in Stunden, wenn nur der Anteil (1 - last_anteil) der Plattenrate für den Rebuild bleibt."""
    return gb * 1000 / (mb_s * (1 - last_anteil)) / 3600

print("## Rebuild-Zeit (eine Platte ersetzen, Rate 150 MB/s als Annahme)")
print(f"{'Plattengröße':>12} {'Last 0 %':>9} {'Last 50 %':>10} {'Last 80 %':>10}")
for tb in (2, 8, 16):
    print(f"{tb:>9} TB " + " ".join(f"{rebuild(tb*1000,150,l):>9.1f}h" for l in (0.0, 0.5, 0.8)))
print("Während des Rebuilds fehlt bei RAID 5 die Reserve; je länger das Fenster, desto größer das Risiko eines zweiten Fehlers.")

print()
print("## USV-Laufzeit (Annahmen: Nennlast der Geräte und nutzbare Batteriekapazität)")
def laufzeit_min(wh_batterie, wirkungsgrad, last_w): return wh_batterie * wirkungsgrad / last_w * 60
for last in (150, 300, 600):
    print(f"  Last {last:>3} W bei 120 Wh Batterie, Wirkungsgrad 0,85 -> {laufzeit_min(120, 0.85, last):5.1f} Minuten")
herunterfahren_min = 8
print(f"\nBenötigte Zeit zum sauberen Herunterfahren (Annahme): {herunterfahren_min} Minuten")
for last in (150, 300, 600):
    t = laufzeit_min(120, 0.85, last)
    print(f"  Last {last:>3} W: {'reicht' if t >= herunterfahren_min * 1.5 else 'reicht NICHT (Faktor 1,5 Sicherheitsreserve)'} ({t:.1f} Minuten gegen {herunterfahren_min*1.5:.0f})")
print("Hinweis: Batterien altern; die Laufzeit sinkt über die Jahre. Messen und regelmäßig testen.")
