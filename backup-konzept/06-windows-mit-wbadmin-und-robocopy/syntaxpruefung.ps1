# Prüft nur die Syntax von PowerShell-Dateien, ohne sie auszuführen.
# Aufruf:  pwsh -NoProfile -File syntaxpruefung.ps1 sicherung_windows.ps1
param([Parameter(Mandatory)][string[]]$Datei)
foreach ($d in $Datei) {
    $t = $null; $e = $null
    [void][System.Management.Automation.Language.Parser]::ParseFile((Resolve-Path $d), [ref]$t, [ref]$e)
    if ($e.Count) { $e | ForEach-Object { "{0}: Zeile {1}: {2}" -f $d, $_.Extent.StartLineNumber, $_.Message } }
    else { "{0}: keine Syntaxfehler" -f $d }
}
