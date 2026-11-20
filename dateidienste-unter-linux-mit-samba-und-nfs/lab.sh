#!/usr/bin/env bash
# Gemeinsame Hilfen der Übungsreihe (P55). Nur im Testlabor als root ausführen.
# Startet einen Samba-Server (Standalone) auf 127.0.0.1:4455 mit Dateien unter /tmp/p55 und legt die Testbenutzer anna und ben an.
W=/tmp/p55; PORT=4455; PW='Geheim-123'
step() { echo; echo "## $*"; }
cmd() { echo "\$ $*"; "$@" 2>&1; return $?; }
# Konfiguration schreiben: smb_conf "zusätzliche [global]-Zeilen" "Freigabe-Abschnitte"
smb_conf() {
  mkdir -p $W/{priv,lock,state,cache,pid,ncalrpc}
  cat > $W/smb.conf <<EOF
[global]
 workgroup = LAB
 server role = standalone server
 map to guest = never
 log level = 1
 private dir = $W/priv
 lock directory = $W/lock
 state directory = $W/state
 cache directory = $W/cache
 pid directory = $W/pid
 ncalrpc dir = $W/ncalrpc
 smb ports = $PORT
 bind interfaces only = yes
 interfaces = 127.0.0.1
 passdb backend = tdbsam:$W/priv/passdb.tdb
 log file = $W/log.%m
 $1

$2
EOF
}
lab_users() {
  for g in projekt; do getent group $g >/dev/null || groupadd $g; done
  for u in anna ben; do id $u >/dev/null 2>&1 || useradd -M -s /usr/sbin/nologin $u; done
  usermod -aG projekt anna; usermod -aG projekt ben
  for u in anna ben; do printf "$PW\n$PW\n" | smbpasswd -c $W/smb.conf -a -s $u >/dev/null 2>&1; done
}
smb_start() { smbd -s $W/smb.conf -D; sleep 2; }
smb_stop() { [ -f $W/pid/smbd.pid ] && kill $(cat $W/pid/smbd.pid) 2>/dev/null; pkill -f "smbd -s $W/smb.conf" 2>/dev/null; sleep 1; }
# smbclient-Aufruf: sc BENUTZER FREIGABE "Befehle" [weitere Optionen]
sc() { local u=$1 s=$2 c=$3; shift 3; smbclient -p $PORT "//127.0.0.1/$s" -U "$u%$PW" "$@" -c "$c" 2>&1; }
lab_up() { lab_down >/dev/null 2>&1; mkdir -p $W; }
lab_down() {
  smb_stop
  for u in anna ben; do id $u >/dev/null 2>&1 && userdel $u 2>/dev/null; done
  getent group projekt >/dev/null && groupdel projekt 2>/dev/null
  rm -rf $W
  return 0
}
