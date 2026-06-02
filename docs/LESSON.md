# LESSON.md — knowledge accumulato (Laravel Rebel)

> **Regola:** questo file va **letto all'inizio di ogni sessione** e **passato nel contesto a ogni subagent** lanciato in parallelo. È append-only, con data. Ogni volta che si impara qualcosa (anche dai commenti di Copilot review) si aggiunge una voce.

Formato voce:
```
## [YYYY-MM-DD] #N — Titolo breve
Contesto · Cosa è successo · Lezione/Regola operativa.
```

---

## [2026-06-02] #1 — `copilot` CLI: usare SEMPRE `-p` (prompt mode)
Contesto: probe del toolchain. `copilot --version` (senza `-p`) **si blocca** (modalità interattiva, attende stdin) e ha hangato il comando in background.
Lezione: per la review locale usare **solo** la forma non interattiva: `copilot --yolo -p "/review ..."`. Mai `copilot` nudo in un contesto non interattivo. Se serve passare un diff grande, salvarlo su file temp e referenziarlo.
**VERIFICATO 2026-06-02:** `copilot --yolo -p "..."` funziona non-interattivo, exit 0, output su stdout. Costo ~**7 AI Credits** per una call banale (~6s, 19k token in input). `--yolo` abilita i tool (lettura file) → posso passargli il path del file diff e lui lo legge. Tenere d'occhio il costo credits su review di diff grandi.

## [2026-06-02] #2 — Banner condiviso: sorgente e destinazione
Contesto: banner unico per tutti i package.
Lezione: sorgente = `C:\Users\lopad\Downloads\laravel-rebel\Laravel-Rebel-banner.png`. Va copiato **fisicamente** in `resources/screenshoots/Laravel-Rebel-banner.png` di OGNI repo (cartella `screenshoots`, con la doppia "o", convenzione utente). Usare `scripts/sync-banner.ps1`.

## [2026-06-02] #3 — Toolchain locale verificato
Contesto: ambiente Windows + xampp.
Lezione: PHP 8.4.21, Composer 2.9.7, Node 25 / npm 11.6, `gh` autenticato (lopadova, SSH), `copilot.exe` (WinGet). Target package: **Laravel 12+13, PHP 8.3/8.4/8.5**; Testbench `^10|^11`, Pest 4, Larastan 3 (PHPStan max), Pint. Repo in `C:\xampp\htdocs\laravel-rebel-*`, branch `main`, remote SSH.

## [2026-06-02] #4 — `gh ... --add-reviewer @copilot` da verificare
Contesto: gate GitHub della PR macro→main prevede Copilot come reviewer.
Lezione: richiede Copilot code review abilitato sul repo/org e `gh >= 2.88`. Alla prima PR verificare che la richiesta parta (`gh pr view <n> --json reviewRequests,reviews`). Se non disponibile, il gate primario resta la **review Copilot LOCALE** + CI verdi; annotare qui l'esito reale e procedere.

## [2026-06-02] #6 — PowerShell gotchas (da review Copilot su scripts)
Contesto: prima review Copilot locale (costo 11.7 credits, ~1min) sui miei script PS.
Lezioni (valide per tutti gli script futuri):
- `$array | Measure-Object -Line` ritorna **0** su array di stringhe (`-Line` conta i `\n` *dentro* le stringhe). Per contare gli elementi usa `($array).Count`.
- `Out-File -Encoding utf8` su PS5.x scrive **con BOM**. Per file passati ad altri tool usa `[System.IO.File]::WriteAllText($p, $text, [System.Text.UTF8Encoding]::new($false))` (no BOM, cross-versione).
- Dopo `git`/`gh` controllare **`$LASTEXITCODE`** (gli errori non lanciano eccezioni in PS): es. `gh pr create` fallito lascia `$num` errato.
- `Copy-Item` aggiungere `-ErrorAction Stop`; verificare `Test-Path` su sorgente e root.
- Quota `'@copilot'` nei comandi `gh` (sicuro anche in bash/zsh).
Processo: la review Copilot LOCALE funziona e trova bug reali → tenerla sempre nel loop.

## [2026-06-02] #5 — README didattici (requisito di prodotto)
Contesto: indicazione utente. L'ecosistema è complesso/enterprise.
Lezione: ogni README deve essere **prolisso e didattico** per junior/non-esperti di auth: spiegare cosa fa, come funziona (passo-passo + ASCII), come si monta, OGNI opzione di config (tabella), e **molti esempi** (≥4-6 per package). Glossario dei termini (OTP, step-up, AAL, passkey, dynamic linking). Meglio "troppo spiegato" che criptico.
