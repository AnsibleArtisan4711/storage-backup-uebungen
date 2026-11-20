#!/usr/bin/env bash
# Partitionstabellen MBR und GPT auf einer Image-Datei (Loop-Gerät, erfundene Daten).
cd "$(dirname "$0")" || exit 1
. ../lab.sh
lab_up; truncate -s 200M $W/a.img
step "1. GPT anlegen: zwei Partitionen (50 MiB und Rest)"
cmd sfdisk -q $W/a.img <<'EOF'
label: gpt
size=50MiB, name=daten
name=archiv
EOF
step "2. Tabelle lesen (sfdisk -l, Kennung ausgeblendet)"
sfdisk -l $W/a.img | grep -v -E "^Disk identifier|^Disk /"
step "3. Dieselbe Platte als MBR (msdos) neu aufteilen: vier primäre Partitionen sind das Maximum"
cmd sfdisk -q $W/a.img <<'EOF'
label: dos
size=20MiB, type=83
size=20MiB, type=83
size=20MiB, type=83
size=20MiB, type=83
EOF
sfdisk -l $W/a.img | grep -E "^/|^Disklabel"
lab_down
