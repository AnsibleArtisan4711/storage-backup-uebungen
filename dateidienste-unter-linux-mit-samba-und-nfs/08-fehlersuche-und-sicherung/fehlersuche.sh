#!/usr/bin/env bash
# Fehlersuche und Sicherung: typische Fehlermeldungen provozieren, testparm, Sicherung mit tar samt ACLs (erfundene Daten, Loopback).
cd "$(dirname "$0")" || exit 1
. ../lab.sh
lab_up; mkdir -p $W/daten; chmod 777 $W/daten
smb_conf "" "[daten]
 path = $W/daten
 read only = no"
step "1. Tippfehler in der Konfiguration: testparm findet unbekannte Parameter"
cp $W/smb.conf $W/kaputt.conf; sed -i 's/read only = no/read onyl = no/' $W/kaputt.conf
testparm -s $W/kaputt.conf 2>&1 | grep -i "unknown parameter"
lab_users; smb_start
step "2. Typische Fehlermeldungen"
echo "falsches Passwort:"; smbclient -p $PORT //127.0.0.1/daten -U 'anna%falsch' -c ls 2>&1 | head -1
echo "unbekannte Freigabe:"; sc anna gibtesnicht "ls" | head -1
echo "unbekannter Benutzer:"; smbclient -p $PORT //127.0.0.1/daten -U 'otto%x' -c ls 2>&1 | head -1
echo "Server nicht erreichbar (falscher Port):"; smbclient -p 4466 //127.0.0.1/daten -U "anna%$PW" -c ls 2>&1 | head -1
step "3. Sicherung der Daten samt ACLs und Besitzer (tar --acls --xattrs)"
echo "inhalt" > $W/daten/wichtig.txt; chown anna:projekt $W/daten/wichtig.txt 2>/dev/null; setfacl -m u:ben:r $W/daten/wichtig.txt
tar --acls --xattrs -C $W -czf $W/sicherung.tgz daten
echo "Datei gelöscht und aus der Sicherung wiederhergestellt:"
rm $W/daten/wichtig.txt
tar --acls --xattrs -C $W -xzf $W/sicherung.tgz daten/wichtig.txt
getfacl -p $W/daten/wichtig.txt 2>/dev/null | grep -E "^# owner|^user:ben" 
step "4. Die Samba-Passwortdatenbank gehört in die Sicherung (Datei, keine Klartextpasswörter)"
ls $W/priv | grep -E "passdb" 
lab_down
