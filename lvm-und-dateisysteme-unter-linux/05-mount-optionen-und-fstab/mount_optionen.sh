#!/usr/bin/env bash
# Mount-Optionen und fstab-Prüfung (Loop-Gerät, erfundene Daten).
cd "$(dirname "$0")" || exit 1
. ../lab.sh
lab_up; img_loop e 100M; E=$DEV; mkfs.ext4 -q -L daten $E; mkdir -p $W/m
printf '#!/bin/sh\necho Skript läuft\n' > $W/skript.sh
step "1. Normal einbinden: Skript ausführbar"
mount $E $W/m; cp $W/skript.sh $W/m/; chmod +x $W/m/skript.sh; cmd $W/m/skript.sh; umount $W/m
step "2. Mit noexec: Ausführen wird verweigert"
mount -o noexec $E $W/m; $W/m/skript.sh 2>&1 | sed "s#$W#...#"; umount $W/m
step "3. Mit ro: Schreiben wird verweigert"
mount -o ro $E $W/m; touch $W/m/neu 2>&1 | sed "s#$W#...#"; umount $W/m
step "4. Optionen im laufenden Betrieb ändern (remount)"
mount $E $W/m; mount -o remount,ro $W/m; findmnt -no OPTIONS $W/m | tr ',' '\n' | grep -E '^(ro|rw)$'
mount -o remount,rw $W/m; findmnt -no OPTIONS $W/m | tr ',' '\n' | grep -E '^(ro|rw)$'; umount $W/m
step "5. fstab-Datei prüfen (eigene Datei, nicht /etc/fstab)"
UUID=$(blkid -s UUID -o value $E)
printf 'UUID=%s %s ext4 defaults,noexec 0 2\nUUID=gibt-es-nicht /mnt/x ext4 defaults 0 2\n' "$UUID" "$W/m" > $W/fstab
findmnt --verify --tab-file $W/fstab 2>&1 | sed -E "s#$W#...#g; s#$UUID#<UUID>#g" | head -8
lab_down
