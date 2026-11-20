"""MBR und GPT: Grenzen aus Sektorgröße und Adressbreite (Rechenmodell, erfundene Beispiele)."""
def groesse(sektoren, sektor=512):
    return sektoren * sektor
def fmt(b):
    for u in ("B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB"):
        if b < 1024: return "%.2f %s" % (b, u)
        b /= 1024
    return "%.2f YiB" % b
print("MBR: Sektornummer 32 Bit")
for s in (512, 4096):
    print("  Sektor %4d Byte: höchstens %s" % (s, fmt(groesse(2**32, s))))
print("GPT: Sektornummer 64 Bit")
for s in (512, 4096):
    print("  Sektor %4d Byte: höchstens %s" % (s, fmt(groesse(2**64, s))))
print("\nPartitionen: MBR 4 primäre (oder 3 + 1 erweiterte); GPT in der Regel 128 Einträge (Standardwert)")
platte = 3 * 1024**4
print("\nPlatte mit %s: MBR nutzbar %s, ungenutzt %s" % (fmt(platte), fmt(min(platte, groesse(2**32))), fmt(max(0, platte - groesse(2**32)))))
