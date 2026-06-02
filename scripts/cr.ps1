# Review Copilot LOCALE del diff del branch corrente vs origin/main.
# Uso: pwsh scripts/cr.ps1   (dalla root del repo)
param(
  [string]$Base = 'origin/main',
  [string]$Prompt = '/review questo diff. Trova: bug, problemi di sicurezza (OTP/secret nei log, enumeration, replay, tenant leakage), violazioni stile/Pint, guardrail/test mancanti. Rispondi conciso e azionabile, elenco puntato.'
)
git fetch origin --quiet 2>$null
$diff = git diff "$Base...HEAD"
if (-not $diff) { Write-Output "Nessun diff vs $Base."; exit 0 }
$tmp = Join-Path $env:TEMP ("rebel-cr-" + (Get-Random) + ".diff")
$diff | Out-File -FilePath $tmp -Encoding utf8
$lines = ($diff | Measure-Object -Line).Lines
Write-Output "Diff salvato in $tmp ($lines righe). Avvio Copilot review (non interattivo)..."
# NB: SEMPRE -p (mai copilot nudo: si blocca). --yolo abilita i tool (lettura file).
copilot --yolo -p "$Prompt`n`nLeggi il diff dal file: $tmp"
