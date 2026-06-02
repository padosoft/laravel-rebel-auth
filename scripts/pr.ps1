# Apre la PR macro->main, richiede la review di @copilot e mostra lo stato.
# Uso: pwsh scripts/pr.ps1 -Title "feat(core): ..." [-Body "..."] [-Base main]
param(
  [Parameter(Mandatory=$true)][string]$Title,
  [string]$Body = 'Vedi docs/IMPLEMENTATION-PLAN.md. Gate: CI verdi + review Copilot.',
  [string]$Base = 'main'
)
git push -u origin (git rev-parse --abbrev-ref HEAD)
gh pr create --title $Title --body $Body --base $Base
$num = gh pr view --json number -q '.number'
Write-Output "PR #$num creata. Richiedo review @copilot..."
# Se @copilot non e' disponibile come reviewer, annota in docs/LESSON.md e prosegui col gate locale+CI.
gh pr edit $num --add-reviewer '@copilot' 2>&1
Start-Sleep -Seconds 3
gh pr view $num --json reviewRequests,reviews,statusCheckRollup
