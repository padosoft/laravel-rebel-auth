# Review Copilot LOCALE del diff del branch corrente vs origin/main.
# Uso: pwsh scripts/cr.ps1   (dalla root del repo)
param(
  [string]$Base = 'origin/main',
  [string]$Prompt = '/review questo diff. Trova: bug, problemi di sicurezza (OTP/secret nei log, enumeration, replay, tenant leakage), violazioni stile/Pint, guardrail/test mancanti. Rispondi conciso e azionabile, elenco puntato; se nulla di rilevante scrivi NO_ISSUES.'
)
git fetch origin --quiet 2>$null
$diff = git diff "$Base...HEAD"
if ($LASTEXITCODE -ne 0) { throw "git diff fallito (ref '$Base' valido?)" }
if (-not $diff) { Write-Output "Nessun diff vs $Base."; exit 0 }
$tmp = Join-Path $env:TEMP ("rebel-cr-" + (Get-Random) + ".diff")
# UTF-8 SENZA BOM (Measure-Object -Line conta i \n dentro le stringhe -> uso .Count per gli elementi)
[System.IO.File]::WriteAllText($tmp, (($diff -join "`n")), [System.Text.UTF8Encoding]::new($false))
Write-Output "Diff salvato in $tmp ($(($diff).Count) righe). Avvio Copilot review (non interattivo)..."
# NB: SEMPRE -p (mai copilot nudo: si blocca). --yolo abilita i tool (lettura file).
copilot --yolo -p "$Prompt`n`nLeggi il diff dal file: $tmp"
