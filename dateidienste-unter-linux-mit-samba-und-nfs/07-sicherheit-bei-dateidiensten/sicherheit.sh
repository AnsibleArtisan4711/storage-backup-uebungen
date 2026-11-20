#!/usr/bin/env bash
# Sicherheit: Protokollversionen, Signierung, Verschlüsselung (erfundene Daten, Loopback).
cd "$(dirname "$0")" || exit 1
. ../lab.sh
lab_up; mkdir -p $W/daten
smb_conf "server min protocol = SMB2
 server signing = mandatory
 server smb encrypt = required" "[daten]
 path = $W/daten
 read only = no"
lab_users; chmod 777 $W/daten; smb_start
step "1. Konfiguration (Auszug aus testparm; Samba 4.19: Parametername server smb encrypt)"
testparm -s $W/smb.conf 2>/dev/null | grep -E "min protocol|signing|encrypt"
step "2. Anmeldung mit SMB3 funktioniert"
sc anna daten "ls" -m SMB3 | grep -c "blocks"
step "3. Anmeldung mit dem alten Protokoll NT1 (SMB1) wird abgelehnt"
sc anna daten "ls" -m NT1 --option="client min protocol=NT1" | head -2
step "4. Verschlüsselung erzwingen: Client ohne Verschlüsselung (SMB2) scheitert, mit Verschlüsselung (SMB3) funktioniert"
echo "ohne Verschlüsselung (SMB2):"; sc anna daten "ls" -m SMB2 | head -1
echo "mit Verschlüsselung (SMB3, --client-protection=encrypt):"; sc anna daten "ls" -m SMB3 --client-protection=encrypt | grep -c "blocks"
lab_down
