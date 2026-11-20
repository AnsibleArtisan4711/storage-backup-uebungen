#!/usr/bin/env bash
# Btrfs-Kompression: Wirkung auf gut und schlecht komprimierbare Daten messen (Loop-Gerät, erfundene Daten).
cd "$(dirname "$0")" || exit 1
. ../lab.sh
lab_up; img_loop a 400M
# Testtext: 30 MiB aus zufällig gewählten Wörtern (fester Startwert), damit sich die Verfahren unterscheiden
python3 - "$W/text.src" <<'PY'
import random, sys
r = random.Random(1); w = [''.join(r.choice('abcdefghiklmnoprstuw') for _ in range(r.randint(3, 9))) for _ in range(800)]
out = open(sys.argv[1], 'w'); n = 0
while n < 30 * 1024 * 1024:
    z = ' '.join(r.choice(w) for _ in range(12)) + '\n'; out.write(z); n += len(z)
PY
head -c 30M $W/text.src > $W/text.tmp; mv $W/text.tmp $W/text.src
run() {   # run OPTION: neues Dateisystem, Daten schreiben, Belegung messen
  mkfs.btrfs -q -f $DEV; mount ${1:+-o $1} $DEV $W/mnt
  cp $W/text.src $W/mnt/text.dat
  head -c 10M /dev/urandom > $W/mnt/zufall.dat; sync
  printf '%-14s ' "${1:-keine}"
  for f in text.dat zufall.dat; do
    compsize -b $W/mnt/$f | awk -v f=$f '/^TOTAL/{printf "%s: Platte %.1f MiB von %.1f MiB (%s)   ", f, $3/1048576, $4/1048576, $2}'
  done; echo
  umount $W/mnt
}
step "Belegung auf der Platte je Mount-Option (Text 30 MiB gut komprimierbar, Zufall 10 MiB nicht)"
run ""
run "compress=zstd:3"
run "compress=zlib"
run "compress=lzo"
step "compress-force: auch Daten komprimieren, die als unkomprimierbar erkannt würden"
run "compress-force=zstd:3"
step "Kompression nachträglich auf vorhandene Dateien anwenden (btrfs filesystem defragment -czstd)"
mkfs.btrfs -q -f $DEV; mount $DEV $W/mnt
cp $W/text.src $W/mnt/alt.dat; sync
echo "vorher:  $(compsize -b $W/mnt/alt.dat | awk '/^TOTAL/{printf "Platte %.1f MiB von %.1f MiB", $3/1048576, $4/1048576}')"
btrfs filesystem defragment -czstd $W/mnt/alt.dat; sync
echo "nachher: $(compsize -b $W/mnt/alt.dat | awk '/^TOTAL/{printf "Platte %.1f MiB von %.1f MiB", $3/1048576, $4/1048576}')"
cd /; lab_down
