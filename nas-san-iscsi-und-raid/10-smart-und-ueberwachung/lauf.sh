#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1
. ../lab.sh
echo "## 1. smartctl gegen ein virtuelles Loop-Gerät: keine SMART-Daten"
lab_up; img_loop s 16M
smartctl --version | head -1
cmd smartctl -i $DEV
echo "(Ein virtuelles Gerät hat kein SMART; in der Hyper-V-VM mit virtuellen Platten ist es ebenso. SMART gibt es nur am echten Laufwerk.)"
losetup -d $DEV; lab_down
echo; echo "## 2. Auswertung erfundener smartctl-Ausgaben"
python3 smart_auswerten.py smart_platte_gut.txt smart_platte_auffaellig.txt
