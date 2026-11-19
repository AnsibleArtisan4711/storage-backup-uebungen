<#
.SYNOPSIS
  Sichert ein Datenlaufwerk mit Windows Server Backup (wbadmin) und legt eine Dateikopie mit robocopy an.
.DESCRIPTION
  Entwurf für das Lab (WS01). Ohne -Ausfuehren zeigt das Skript nur die Befehle und führt robocopy mit /L aus (Trockenlauf).
  Parameter: Quelle = zu sicherndes Laufwerk, WbZiel = Ziel für wbadmin (eigenes Laufwerk, nicht die Quelle),
  KopieZiel = Ordner für die robocopy-Kopie (zum Beispiel auf einer später offline genommenen Platte).
  Nicht auf Windows ausgeführt. Befehle gegen Microsoft Learn gelesen (Stand 19.11.2026), Ausgaben nicht bestätigt.
#>
param(
    [string]$Quelle = 'D:',
    [string]$WbZiel = 'E:',
    [string]$QuellOrdner = 'D:\Daten',
    [string]$KopieZiel = 'F:\Kopie',
    [string]$LogOrdner = 'C:\Backup-Logs',
    [switch]$Ausfuehren
)
$ErrorActionPreference = 'Stop'
if ($Quelle.TrimEnd('\') -ieq $WbZiel.TrimEnd('\')) { throw 'Quelle und wbadmin-Ziel dürfen nicht dasselbe Laufwerk sein.' }
$stempel = Get-Date -Format 'yyyy-MM-dd_HHmmss'
if (-not (Test-Path $LogOrdner)) { New-Item -ItemType Directory -Path $LogOrdner | Out-Null }
$log = Join-Path $LogOrdner "sicherung_$stempel.log"

function Schritt([string]$Text) { "{0}  {1}" -f (Get-Date -Format 'HH:mm:ss'), $Text | Tee-Object -FilePath $log -Append }

# 1. Windows Server Backup bereitstellen (Featurename nicht bestätigt, Cmdlet laut Learn)
Schritt 'Prüfe Feature Windows-Server-Backup'
$f = Get-WindowsFeature -Name Windows-Server-Backup
if (-not $f.Installed) {
    Schritt 'Installiere Windows-Server-Backup'
    if ($Ausfuehren) { Install-WindowsFeature -Name Windows-Server-Backup | Out-Null }
}

# 2. Sicherung des Laufwerks (Syntax laut Learn: wbadmin start backup)
$wb = @('start', 'backup', "-backupTarget:$WbZiel", "-include:$Quelle", '-quiet')
Schritt ('wbadmin ' + ($wb -join ' '))
if ($Ausfuehren) {
    & wbadmin @wb 2>&1 | Tee-Object -FilePath $log -Append
    if ($LASTEXITCODE -ne 0) { Schritt "FEHLER: wbadmin Rückgabewert $LASTEXITCODE"; exit $LASTEXITCODE }
}

# 3. Dateikopie auf ein weiteres Medium (robocopy: 0 bis 7 = Erfolg, ab 8 Fehler)
$rc = @($QuellOrdner, $KopieZiel, '/E', '/COPY:DAT', '/R:2', '/W:5', '/NP', "/LOG+:$log")
if (-not $Ausfuehren) { $rc += '/L' }
Schritt ('robocopy ' + ($rc -join ' '))
& robocopy @rc | Out-Null
if ($LASTEXITCODE -ge 8) { Schritt "FEHLER: robocopy Rückgabewert $LASTEXITCODE"; exit $LASTEXITCODE }

# 4. Vorhandene Sicherungsversionen anzeigen
if ($Ausfuehren) { & wbadmin get versions 2>&1 | Tee-Object -FilePath $log -Append }
Schritt 'Fertig'
