#!/usr/bin/env bash
# Freigaben und Berechtigungen: valid users, read only, force group, create mask; Zusammenspiel mit POSIX-Rechten (erfundene Daten, Loopback).
cd "$(dirname "$0")" || exit 1
. ../lab.sh
lab_up; mkdir -p $W/projekt $W/info $W/privat
smb_conf "" "[projekt]
 path = $W/projekt
 read only = no
 valid users = @projekt
 force group = projekt
 create mask = 0660
 directory mask = 0770

[info]
 path = $W/info
 read only = yes
 write list = anna

[privat]
 path = $W/privat
 read only = no
 valid users = anna"
lab_users
chgrp projekt $W/projekt; chmod 2770 $W/projekt; chmod 755 $W/info; chown anna $W/info; chown anna $W/privat; chmod 700 $W/privat
smb_start
step "1. Gruppenfreigabe: anna legt eine Datei an, ben liest sie"
sc anna projekt "put /etc/hostname plan.txt" >/dev/null
ls -l $W/projekt | grep -v '^total' | awk '{print $1, $3, $4, $9}'
sc ben projekt "get plan.txt $W/plan_ben.txt" | grep -o "getting file.*plan.txt" | head -1
step "2. Freigabe mit read only und write list (nur anna schreibt)"
echo "ben:"; sc ben info "put /etc/hostname x.txt" | grep -E "NT_STATUS"
echo "anna:"; sc anna info "put /etc/hostname x.txt" | grep -c "putting file"
step "3. valid users: ben darf nicht auf die Freigabe privat"
sc ben privat "ls" | head -1
step "4. Freigaberecht und Dateirecht wirken zusammen: Verzeichnis gehört root, Freigabe erlaubt schreiben"
mkdir -p $W/nur_root; chmod 755 $W/nur_root
smb_stop; smb_conf "" "[nur_root]
 path = $W/nur_root
 read only = no"; smb_start
sc anna nur_root "put /etc/hostname y.txt" | grep -E "NT_STATUS"
lab_down
