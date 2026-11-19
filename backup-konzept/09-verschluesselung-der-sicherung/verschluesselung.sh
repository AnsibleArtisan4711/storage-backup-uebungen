#!/bin/bash
# Sicherungen verschlüsseln: gpg (symmetrisch), openssl enc (AES-256 mit PBKDF2) und restic-Schlüsselverwaltung.
# Alle Kennwörter sind Laborwerte. Aufruf: bash verschluesselung.sh [Arbeitsordner]
set -u
W="${1:-./lab09}"; rm -rf "$W"; mkdir -p "$W/daten" && cd "$W"
export GNUPGHOME="$PWD/gnupg"; mkdir -m 700 "$GNUPGHOME"
for i in 1 2 3; do echo "Vertrauliche Zeile $i" > daten/datei$i.txt; done
tar -cf daten.tar daten
echo "== 1. gpg symmetrisch (AES256)"
echo "LabKennwort-1" > pw1.txt
gpg --batch --quiet --pinentry-mode loopback --passphrase-file pw1.txt --symmetric --cipher-algo AES256 -o daten.tar.gpg daten.tar
ls -l daten.tar daten.tar.gpg | awk '{print $5, $9}'
echo "-- Klartext im Archiv sichtbar?  (grep im verschlüsselten Archiv)"
grep -c "Vertrauliche" daten.tar.gpg || true
echo "-- Entschlüsseln mit richtigem Kennwort"
gpg --batch --quiet --pinentry-mode loopback --passphrase-file pw1.txt -d daten.tar.gpg 2>/dev/null | cmp - daten.tar && echo "identisch"
echo "-- Entschlüsseln mit falschem Kennwort"
echo "falsch" > pwx.txt
gpg --batch --quiet --pinentry-mode loopback --passphrase-file pwx.txt -d daten.tar.gpg >/dev/null 2>gpgfehler.txt; echo "Rückgabewert: $?"; tail -n 1 gpgfehler.txt
echo
echo "== 2. openssl enc (AES-256-CBC, PBKDF2, 600000 Iterationen)"
openssl enc -aes-256-cbc -pbkdf2 -iter 600000 -salt -pass file:pw1.txt -in daten.tar -out daten.tar.enc
openssl enc -d -aes-256-cbc -pbkdf2 -iter 600000 -pass file:pw1.txt -in daten.tar.enc | cmp - daten.tar && echo "identisch"
echo "-- gpg: ein Byte im Chiffrat geändert (gpg meldet den Fehler)"
cp daten.tar.gpg kaputt.gpg; printf '\x00' | dd of=kaputt.gpg bs=1 seek=100 conv=notrunc 2>/dev/null
gpg --batch --quiet --pinentry-mode loopback --passphrase-file pw1.txt -d kaputt.gpg >/dev/null 2>gpgfehler.txt; echo "gpg Rückgabewert: $?"; tail -n 1 gpgfehler.txt
echo
echo "== 3. restic: mehrere Schlüssel, Schlüssel entfernen"
export RESTIC_REPOSITORY="$PWD/repo"
echo "LabKennwort-A" > pwA.txt; echo "LabKennwort-B" > pwB.txt
export RESTIC_PASSWORD_FILE="$PWD/pwA.txt"
restic init -q; restic backup -q daten
restic key list
restic key add --new-password-file pwB.txt 2>&1 | tail -n 1
restic key list
echo "-- Zugriff mit Kennwort B"
RESTIC_PASSWORD_FILE="$PWD/pwB.txt" restic snapshots --compact | tail -n 2
echo "-- Schlüssel A entfernen (Anmeldung mit B)"
IDA=$(restic key list | awk '/^\*/ {sub(/^\*/,"",$1); print $1; exit}')
echo "zu entfernender Schlüssel: $IDA"
RESTIC_PASSWORD_FILE="$PWD/pwB.txt" restic key remove "$IDA" 2>&1 | tail -n 1
echo "-- Zugriff mit A nach dem Entfernen"
restic snapshots 2>&1 | tail -n 1
echo "-- Schlüsselliste jetzt"; RESTIC_PASSWORD_FILE="$PWD/pwB.txt" restic key list
