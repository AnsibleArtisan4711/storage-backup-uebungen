#!/usr/bin/env python3
"""Modell: prüft Zeilen einer /etc/exports mit eigenen Beispielregeln (keine vollständige Prüfung, nicht gegen exports(5) verifiziert)."""
zeilen = [
  "/srv/daten 10.55.0.0/24(rw,sync,no_subtree_check)",
  "/srv/backup *(rw,sync,no_root_squash)",
  "/srv/info 10.55.0.0/24(ro,sync,root_squash)",
  "/srv/tmp 10.55.0.0/24 (rw,sync)",
  "/srv/proj 10.55.0.20(rw,async,no_subtree_check)",
]
def pruefe(z):
    pfad, _, rest = z.partition(" ")
    meld = []
    if rest.startswith(" ") or ") (" in z or " (" in z:
        meld.append("Leerzeichen vor der Klammer: Optionen gelten dann für alle Clients, nicht für den genannten")
    if rest.startswith("*"):
        meld.append("Wildcard * erlaubt jeden Client")
    if "no_root_squash" in z:
        meld.append("no_root_squash: root des Clients ist root auf dem Server")
    if "async" in z:
        meld.append("async: Server bestätigt vor dem Schreiben auf die Platte (Datenverlust bei Absturz möglich)")
    if "sync" not in z:
        meld.append("weder sync noch async angegeben (Standardwert der eingesetzten Version prüfen)")
    return meld or ["ok"]
for z in zeilen:
    print(z)
    for m in pruefe(z):
        print("   ->", m)
