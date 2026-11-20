"""Modell: weiche und harte Grenze, Karenzzeit. Vereinfacht, erfundene Zahlen; kein Abbild von ext4- oder XFS-Quotas."""
def pruefe(belegt_mb, weich=10, hart=15, tage_seit_weich=0, karenz=7):
    if belegt_mb > hart: return "abgelehnt (harte Grenze %d MB)" % hart
    if belegt_mb > weich:
        if tage_seit_weich > karenz: return "abgelehnt (Karenzzeit von %d Tagen abgelaufen)" % karenz
        return "erlaubt mit Warnung (noch %d Tage Karenz)" % (karenz - tage_seit_weich)
    return "erlaubt"
for mb, t in [(5, 0), (12, 0), (12, 3), (12, 9), (16, 0)]:
    print("belegt %2d MB, seit %d Tagen über weich: %s" % (mb, t, pruefe(mb, tage_seit_weich=t)))
