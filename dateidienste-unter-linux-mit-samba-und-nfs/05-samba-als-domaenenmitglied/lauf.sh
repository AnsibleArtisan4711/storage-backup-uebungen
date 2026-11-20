#!/usr/bin/env bash
# Prüft nur die Syntax der Beispielkonfiguration mit testparm; der Beitritt selbst wurde nicht ausgeführt.
cd "$(dirname "$0")" || exit 1
testparm -s domaene_smb.conf 2>&1 | grep -E "Loaded|Server role|security|realm|idmap config LAB|ERROR|Unknown"
