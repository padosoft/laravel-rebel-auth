# Copia il banner condiviso in resources/screenshoots/ di ogni repo laravel-rebel-*
param(
  [string]$Source = 'C:\Users\lopad\Downloads\laravel-rebel\Laravel-Rebel-banner.png',
  [string]$Root   = 'C:\xampp\htdocs'
)
if (-not (Test-Path $Source)) { throw "Banner sorgente non trovato: $Source" }
if (-not (Test-Path $Root))   { throw "Root non trovato: $Root" }
Get-ChildItem $Root -Directory -Filter 'laravel-rebel-*' | ForEach-Object {
  $dest = Join-Path $_.FullName 'resources\screenshoots'
  New-Item -ItemType Directory -Force -Path $dest | Out-Null
  Copy-Item $Source (Join-Path $dest 'Laravel-Rebel-banner.png') -Force -ErrorAction Stop
  Write-Output "banner -> $($_.Name)"
}
