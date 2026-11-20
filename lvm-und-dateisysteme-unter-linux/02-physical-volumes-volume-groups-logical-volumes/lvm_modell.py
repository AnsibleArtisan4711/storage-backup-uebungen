"""Modell: Extents einer Volume Group verteilen (linear). Vereinfacht; kein Abbild von LVM-Metadaten. Erfundene Größen."""
EXT = 4  # MiB
class VG:
    def __init__(self, pvs):  # pvs: {name: MiB}
        self.pe = {n: s // EXT for n, s in pvs.items()}
        self.frei = [(n, i) for n, c in self.pe.items() for i in range(c)]
        self.lv = {}
    def lvcreate(self, name, mib):
        n = -(-mib // EXT)  # aufrunden
        if n > len(self.frei): raise ValueError("zu wenig freie Extents: %d gebraucht, %d frei" % (n, len(self.frei)))
        self.lv[name] = [self.frei.pop(0) for _ in range(n)]
    def lvextend(self, name, mib):
        self.lvcreate("__t", mib); self.lv[name] += self.lv.pop("__t")
    def segmente(self, name):
        seg = []
        for pv, i in self.lv[name]:
            if seg and seg[-1][0] == pv and seg[-1][2] == i - 1: seg[-1][2] = i
            else: seg.append([pv, i, i])
        return ["%s: PE %d-%d" % tuple(s) for s in seg]
vg = VG({"pv1": 300, "pv2": 300})
print("Volume Group: %d Extents zu %d MiB = %d MiB" % (len(vg.frei), EXT, len(vg.frei) * EXT))
vg.lvcreate("daten", 200); vg.lvcreate("log", 150)
for n in ("daten", "log"):
    print("%-5s %4d MiB  %s" % (n, len(vg.lv[n]) * EXT, "; ".join(vg.segmente(n))))
print("frei: %d MiB" % (len(vg.frei) * EXT))
vg.lvextend("daten", 100)
print("daten nach lvextend +100 MiB: %d MiB  %s" % (len(vg.lv["daten"]) * EXT, "; ".join(vg.segmente("daten"))))
try: vg.lvcreate("zu_gross", 500)
except ValueError as e: print("Fehler:", e)
vg.lvcreate("rund", 5); print("rund: 5 MiB angefordert, belegt %d MiB (aufgerundet auf Extents)" % (len(vg.lv["rund"]) * EXT))
