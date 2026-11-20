#!/usr/bin/env bash
# iSCSI-Initiator mit den libiscsi-Werkzeugen (Userspace, ohne Kernel-Initiator): entdecken, abfragen, Zugriffsschutz prüfen
. "$(dirname "$0")/../lab.sh"
lab_up; tgt_up
truncate -s 32M $W/lun1.img
tgtadm --lld iscsi --mode target --op new --tid 1 --targetname $IQN_T
tgtadm --lld iscsi --mode logicalunit --op new --tid 1 --lun 1 --backing-store $W/lun1.img --bstype rdwr
tgtadm --lld iscsi --mode target --op bind --tid 1 --initiator-name $IQN_I
U="iscsi://$PORTAL/$IQN_T/1"
step "1. Erlaubter Initiator: Ziele entdecken (Discovery) und LUN abfragen"
cmd timeout 10 iscsi-ls -i $IQN_I iscsi://$PORTAL
echo "--- Inquiry der LUN 1:"
timeout 10 iscsi-inq -i $IQN_I $U 2>&1 | grep -E 'Device Type|Vendor|Product|Peripheral Device Type'
echo "--- Kapazität:"
timeout 10 iscsi-readcapacity16 -i $IQN_I $U 2>&1 | grep -E 'LOGICAL BLOCK LENGTH|RETURNED LOGICAL|Total size'
step "2. Fremder Initiator-Name: Zugriff verweigert"
echo "\$ iscsi-inq -i iqn.2026-11.example.com:lab.fremd $U"; timeout 10 iscsi-inq -i iqn.2026-11.example.com:lab.fremd $U 2>&1 | head -1
step "3. CHAP aktivieren: ohne Konto abgelehnt, mit Konto erlaubt"
tgtadm --lld iscsi --mode account --op new --user lab --password geheim123456
tgtadm --lld iscsi --mode account --op bind --tid 1 --user lab
echo "\$ iscsi-inq (ohne Konto)"; timeout 10 iscsi-inq -i $IQN_I $U 2>&1 | head -1
echo "\$ iscsi-inq (mit Konto lab)"; timeout 10 iscsi-inq -i $IQN_I "iscsi://lab%geheim123456@$PORTAL/$IQN_T/1" 2>&1 | grep -E 'Peripheral Device Type'
step "4. Namen prüfen mit iqn_pruefen.py"
python3 "$(dirname "$0")/iqn_pruefen.py" $IQN_T $IQN_I iqn.2026-13.example.com:x iqn.2026-11.example.com iqn.2026-11.Example.com:A eui.0123456789ABCDEF nonsense
tgt_down; lab_down
