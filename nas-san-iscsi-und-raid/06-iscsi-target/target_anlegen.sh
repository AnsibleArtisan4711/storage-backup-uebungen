#!/usr/bin/env bash
# iSCSI-Target mit tgt (Userspace): Ziel, LUN, Zugriffsliste, CHAP; Zustand lesen
. "$(dirname "$0")/../lab.sh"
lab_up; tgt_up
step "1. Ziel (Target) mit Namen im IQN-Format anlegen"
cmd tgtadm --lld iscsi --mode target --op new --tid 1 --targetname $IQN_T
step "2. LUN aus einer Image-Datei (statt einer echten Platte) anlegen"
truncate -s 32M $W/lun1.img
cmd tgtadm --lld iscsi --mode logicalunit --op new --tid 1 --lun 1 --backing-store $W/lun1.img --bstype rdwr
step "3. Zugriff nur für einen Initiator-Namen (ACL)"
cmd tgtadm --lld iscsi --mode target --op bind --tid 1 --initiator-name $IQN_I
step "4. CHAP-Konto anlegen und an das Ziel binden"
cmd tgtadm --lld iscsi --mode account --op new --user lab --password geheim123456
cmd tgtadm --lld iscsi --mode account --op bind --tid 1 --user lab
step "5. Zustand lesen (Auszug)"
tgtadm --lld iscsi --mode target --op show | grep -E '^Target|Driver|State|LUN:|Type:|Size:|Backing store path|Account|ACL|lab|iqn' | sed -E 's/ +/ /g'
step "6. Dienst und Port"
echo "Portal: $PORTAL"; ss -ltn | grep -E ':3260 ' | awk '{print $1, $4}'
tgt_down; lab_down
