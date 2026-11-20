#!/usr/bin/env python3
"""Vergleich SMB und NFS. Status L: im Lauf (Skripte der Reihe) geprüft; F: Fachwissen, nicht bestätigt."""
tab = [
  ("Typische Clients", "Windows, auch Linux und macOS", "Linux und Unix, auch Windows (optional)", "F"),
  ("Anmeldung", "Benutzer und Passwort (Samba-Datenbank oder Domäne)", "Rechner/Benutzer über Kerberos oder AUTH_SYS (IP, UID)", "F"),
  ("Anmeldung im Lauf", "Falsches Passwort: NT_STATUS_LOGON_FAILURE", "nicht ausgeführt", "L"),
  ("Versionen", "SMB 2 und 3 (SMB1 veraltet)", "NFSv3, NFSv4.x", "F"),
  ("Samba im Container", "Version 4.19.5", "NFS-Server und -Client nicht nutzbar", "L"),
  ("Berechtigungen", "Windows-ACLs, bei Samba auf POSIX-ACLs abgebildet", "POSIX-Rechte und UID/GID, NFSv4-ACLs möglich", "F"),
  ("Verschlüsselung", "SMB3 (Samba: server smb encrypt)", "Kerberos mit krb5p; sonst unverschlüsselt", "F"),
  ("Verschlüsselung SMB im Lauf", "mit SMB3 und Verschlüsselung funktioniert, ohne scheitert", "–", "L"),
]
w = [max(len(r[i]) for r in tab) for i in range(3)]
print(f"{'Merkmal':<{22}} {'SMB':<{w[1]}}  {'NFS':<{w[2]}}  Status")
for m, s, n, st in tab:
    print(f"{m:<22} {s:<{w[1]}}  {n:<{w[2]}}  {st}")
l = sum(1 for r in tab if r[3] == "L")
print(f"\nL geprüft: {l}, F nicht bestätigt: {len(tab)-l}")
