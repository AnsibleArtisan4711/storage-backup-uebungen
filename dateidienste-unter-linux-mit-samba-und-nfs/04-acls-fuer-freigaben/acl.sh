#!/usr/bin/env bash
# POSIX-ACLs auf einem Freigabeverzeichnis: setfacl, getfacl, Standard-ACL (default), Wirkung über Samba (erfundene Daten, Loopback).
cd "$(dirname "$0")" || exit 1
. ../lab.sh
lab_up; mkdir -p $W/ablage; chown root:root $W/ablage; chmod 750 $W/ablage
smb_conf "" "[ablage]
 path = $W/ablage
 read only = no
 inherit acls = yes"
lab_users; smb_start
step "1. Ohne ACL: anna (nicht Eigentümerin, nicht in der Gruppe) hat keinen Zugriff"
sc anna ablage "ls" | head -1
step "2. ACL setzen: anna darf lesen und schreiben, ben nur lesen; Standard-ACL für neue Dateien"
cmd setfacl -m u:anna:rwx,u:ben:rx $W/ablage
cmd setfacl -d -m u:anna:rwx,u:ben:rx $W/ablage
getfacl -p $W/ablage 2>/dev/null | sed 's#/tmp/p55#<W>#'
step "3. Zugriff über Samba"
echo "anna:"; sc anna ablage "put /etc/hostname a.txt" | grep -c "putting file"
echo "ben schreibt:"; sc ben ablage "put /etc/hostname b.txt" | grep NT_STATUS
echo "ben liest:"; sc ben ablage "get a.txt $W/a_ben.txt" | grep -o "getting file.*a.txt"
step "4. Neue Datei erbt die Standard-ACL"
getfacl -p $W/ablage/a.txt 2>/dev/null | grep -E "^user:|^mask" | sed 's#/tmp/p55#<W>#'
lab_down
