#!/usr/bin/env bash
# Btrfs im Labor ansehen und feststellen, ob ZFS im Container verfügbar ist (Loop-Gerät, erfundene Daten).
cd "$(dirname "$0")" || exit 1
. ../lab.sh
lab_up
step "1. Versionen der Werkzeuge"
cmd btrfs --version
cmd mkfs.btrfs --version
step "2. Kernel-Unterstützung: Dateisysteme, die dieser Kernel kennt"
grep -E 'btrfs|zfs' /proc/filesystems | tr -d '\t' | sed 's/^/  /' || true
echo "btrfs im Kernel: $(grep -qw btrfs /proc/filesystems && echo ja || echo nein); zfs im Kernel: $(grep -qw zfs /proc/filesystems && echo ja || echo nein)"
step "3. ZFS: Programme und Kernelmodul?"
for p in zpool zfs; do printf '  %-6s %s\n' "$p" "$(command -v $p || echo 'nicht installiert')"; done
echo "modprobe: $(command -v modprobe || echo 'nicht installiert')"
echo "Kernelmodul zfs vorhanden: $(find /lib/modules -name 'zfs*' 2>/dev/null | head -1 | grep -q . && echo ja || echo nein)"
echo "Ergebnis: ZFS kann in diesem Container nicht ausgeführt werden; die ZFS-Teile des Kurses sind Modelle und Text (nicht ausgeführt)."
step "4. Ein Btrfs-Dateisystem anlegen und die Grunddaten lesen"
img_loop a 200M
cmd mkfs.btrfs -q -f -L lernpool $DEV
cmd btrfs filesystem show $DEV
echo "-- Super-Block (Auszug):"
btrfs inspect-internal dump-super $DEV | grep -E '^(label|csum_type|csum_size|sectorsize|nodesize)' | sed 's/  */ /g'
mount $DEV $W/mnt
cmd btrfs filesystem df $W/mnt
lab_down
