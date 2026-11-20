#!/usr/bin/env bash
# Samba als Standalone-Server: Konfiguration prüfen, Benutzer anlegen, Server starten, Zugriff testen (erfundene Daten, Loopback).
cd "$(dirname "$0")" || exit 1
. ../lab.sh
lab_up; mkdir -p $W/daten; chmod 777 $W/daten
smb_conf "" "[daten]
 path = $W/daten
 read only = no"
step "1. Konfiguration prüfen (testparm, Auszug)"
testparm -s $W/smb.conf 2>/dev/null | grep -E "^\[|server role|workgroup|path|read only|smb ports"
step "2. Benutzer: Linux-Konto (ohne Anmeldung) und Samba-Passwort"
lab_users; pdbedit -L -s $W/smb.conf 2>/dev/null | cut -d: -f1 | sort
step "3. Server starten, Anmeldung und Dateien"
smb_start
sc anna daten "put /etc/hostname hallo.txt; ls" | grep -E "hallo.txt +A" | awk '{print $1, $2, $3}' 
step "4. Wem gehört die Datei auf dem Linux-Dateisystem?"
ls -l $W/daten | grep -v '^total' | awk '{print $1, $3, $4, $9}'
step "5. Falsches Passwort"
smbclient -p $PORT //127.0.0.1/daten -U 'anna%falsch' -c ls 2>&1 | head -2
lab_down
