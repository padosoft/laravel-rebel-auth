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

## [2026-06-02] #4 — `@copilot` reviewer NON disponibile su questo repo/account → gate = review LOCALE + CI
Contesto: PR #1 (laravel-rebel-auth). gh 2.88.0.
**VERIFICATO:** `gh pr edit <n> --add-reviewer '@copilot'` → **exit 0 ma non aggiunge nulla** (`reviewRequests` resta `[]`, no-op silenzioso). `--add-reviewer 'Copilot'` → **errore** `GraphQL: Could not resolve user with login 'copilot' (requestReviewsByLogin)`.
**UPDATE 2026-06-02 (utente):** l'utente HA **Copilot Plus** sul proprio account (gh loggato come lopadova) → la review `@copilot` sulle PR **dovrebbe funzionare**. Quindi il no-op precedente è probabilmente una questione di **sintassi/endpoint**, non di disponibilità. **DA RITENTARE sulla PR di `core`** provando: (a) `gh pr create ... --reviewer "@copilot"`; (b) REST API `gh api repos/OWNER/REPO/pulls/N/requested_reviewers -f 'reviewers[]=copilot-pull-request-reviewer[bot]'`; (c) verificare con `gh pr view N --json reviewRequests`. Annotare qui la forma che FUNZIONA. Nel frattempo la review Copilot LOCALE (`scripts/cr.ps1`) resta nel loop come backup.
**RISOLTO 2026-06-03 (PR core #1):** il metodo che FUNZIONA per richiedere la review di Copilot è la **REST API**, non `gh pr edit`:
```
gh api --method POST "repos/OWNER/REPO/pulls/N/requested_reviewers" -f "reviewers[]=copilot-pull-request-reviewer[bot]"
```
La risposta mostra `requested_reviewers: [{login:"Copilot", type:"Bot"}]` → richiesta andata. NB: `gh pr view --json reviewRequests` può mostrare `[]` (non elenca i bot) — verificare invece via REST (`gh api .../pulls/N` campo `requested_reviewers`) o via `gh api .../pulls/N/reviews` per la review pubblicata. `gh pr edit --add-reviewer '@copilot'` resta un **no-op silenzioso** (non usarlo). CI matrix (8.3/8.4/8.5 × L12/13 + quality) tutta verde alla prima.

## [2026-06-02] #6 — PowerShell gotchas (da review Copilot su scripts)
Contesto: prima review Copilot locale (costo 11.7 credits, ~1min) sui miei script PS.
Lezioni (valide per tutti gli script futuri):
- `$array | Measure-Object -Line` ritorna **0** su array di stringhe (`-Line` conta i `\n` *dentro* le stringhe). Per contare gli elementi usa `($array).Count`.
- `Out-File -Encoding utf8` su PS5.x scrive **con BOM**. Per file passati ad altri tool usa `[System.IO.File]::WriteAllText($p, $text, [System.Text.UTF8Encoding]::new($false))` (no BOM, cross-versione).
- Dopo `git`/`gh` controllare **`$LASTEXITCODE`** (gli errori non lanciano eccezioni in PS): es. `gh pr create` fallito lascia `$num` errato.
- `Copy-Item` aggiungere `-ErrorAction Stop`; verificare `Test-Path` su sorgente e root.
- Quota `'@copilot'` nei comandi `gh` (sicuro anche in bash/zsh).
Processo: la review Copilot LOCALE funziona e trova bug reali → tenerla sempre nel loop.

## [2026-06-02] #7 — PHPStan level max: niente cast su `mixed`, niente `@var` override
Contesto: T1 core, PHPStan max segnalava `cast.int`/`cast.string` su `(int)/(string) Config::get()`.
Lezioni:
- `Config::get()` ritorna **mixed**: castarlo a int/string è errore a level max (e la config strict vieta `@var`/cast/`assert` per zittire).
- Pattern corretto: risolvi un **tipo concreto** dal container — `$app->make(\Illuminate\Contracts\Config\Repository::class)` è **tipizzato da Larastan** come `Repository` (niente `@var`). Poi **narrowing** con `is_int()/is_string()/is_array()` invece di cast: `$v = is_int($x) ? $x : 1;`.
- Per array tipizzati (es. `array<int,string>` da config) costruisci con un `foreach` filtrante (`if (is_int($k) && is_string($v))`) invece di `(array)$x` + `@var`.

## [2026-06-02] #8 — Eseguire i binari vendor su Windows/pwsh
Contesto: `& "$repo\vendor\bin\phpstan"` → errore "Cannot run a document in the middle of a pipeline" (script senza estensione).
Lezione: usa **`composer <script> --working-dir=$repo`** (pest/phpstan/pint) oppure `php "$repo\vendor\bin\xxx"`. Per leggere errori PHPStan: redirigi `*>&1 | Out-File tmp` e poi `Get-Content`/`Select-String` (il footer mostra solo il riepilogo).

## [2026-06-02] #9 — La review Copilot locale trova bug di design reali
Contesto: review sul diff core (~1300 righe, ~25 credits, ~1.5min). Findings utili: validare l'algo HMAC nel costruttore (fail fast), campo `restricted` era dead-code (aggiunto `rejectRestricted` a `satisfies()`), masking email a 1 char rivelava tutta la local part. Uno (timing su keyVersion) era **non-issue** (keyVersion non è segreta) → documentato, non "aggiustato" a caso. Lezione: valutare ogni commento nel merito (skill receiving-code-review), accettare i validi con test, respingere i falsi con motivazione scritta.

## [2026-06-03] #10 — Dipendenze tra package (core) prima di Packagist: usare VCS repo
Contesto: `email-otp` dipende da `padosoft/laravel-rebel-core` non ancora su Packagist.
Lezione: nel `composer.json` del package dipendente aggiungere `"repositories": [{"type":"vcs","url":"https://github.com/padosoft/laravel-rebel-core"}]` e richiedere `"padosoft/laravel-rebel-core": "^0.1"`. Composer risolve dal **tag GitHub** (v0.1.0). Funziona **in locale e in CI** (repo pubblico, nessuna auth). Quando i package saranno su Packagist si potranno togliere le `repositories`. Il `TestCase` del package dipendente deve registrare **entrambi** i provider (core + package) e impostare un pepper di test (`rebel-core.peppers`). composer update verde, skeleton test verde.

## [2026-06-03] #11 — Pattern Eloquent + PHPStan max (da T2 email-otp)
Contesto: l'engine OTP usa un model Eloquent → diverse insidie a level max.
Lezioni:
- **PHPStan OOM**: model con cast/relazioni esplode la memoria → nel composer script usare `phpstan analyse --memory-limit=512M` (128M default insufficiente). Adottare per tutti i package con model.
- **Proprietà magiche**: a level max servono `@property` per OGNI attributo del model usato (altrimenti `property.notFound`). Meglio `@property` tipizzati che `getAttribute()` (ritorna `mixed` → rompe i parametri tipizzati a valle).
- **`Connection::transaction`**: larastan inferisce il tipo di ritorno dal closure SOLO sul tipo concreto `Illuminate\Database\Connection` (via `DatabaseManager->connection()`), **non** su `ConnectionInterface` (resta `mixed`). Iniettare `DatabaseManager`, fare `->connection()->transaction(fn(): T => ...)`.
- **Cast immutable_datetime**: la proprietà è `CarbonImmutable`; assegnare un `DateTimeImmutable` (da `ClockInterface::now()`) dà errore → `CarbonImmutable::instance($now)`.
- **Migrazioni in test di package dipendenti**: il `TestCase` deve `loadMigrationsFrom` ANCHE le migrazioni della dipendenza (es. core) da `vendor/.../database/migrations` (spatie `hasMigration` pubblica ma non auto-carica in test).
- **Catturare l'OTP nei test**: `Notification::fake()` + `assertSentOnDemand(EmailOtpNotification::class, fn($n)=>...$code=$n->code...)`.

## [2026-06-03] #12 — Pattern di sicurezza per gli engine (da review email-otp)
Contesto: le review (locale + Codex su PR) hanno trovato bug di sicurezza ricorrenti. Da applicare a step-up/channels/recovery.
- **Tenant null ≠ "tutti i tenant"**: `when($t !== null, where tenant)` lascia la query senza filtro quando null → cross-tenant. Usare SEMPRE il two-callback: `when($t===null, whereNull('tenant_id'), where('tenant_id',$t))`. Vale per invalidazioni, idempotency E **lookup di verifica** (verificare nello stesso contesto-tenant).
- **Race su limiti** (max_resends...): leggere+decidere dentro `transaction()` con `lockForUpdate`.
- **Segreti nei job**: notifiche/job che portano OTP/secret → `implements ShouldBeEncrypted` (payload coda cifrato; no leak in `failed_jobs`).
- **Cooldown**: basarlo su `created_at` (invio), non `updated_at` (i fallimenti di verify lo resettano).
- **Controller**: legare `challenge_id` alla **sessione** (no brute force diretto di challenge altrui).
- **Audit completo**: loggare anche i rami early-return (es. `Blocked`).
- **UI da config**: `maxlength` dell'input OTP dal config `digits` (no hardcoded 6).
- **Larastan view-string**: `view('ns::x')` triggera la regola su package view non risolvibili → usare `response()->view('ns::x', $data)` nei controller.
- **Test route in package**: serve `app.key` nel TestCase (`config(['app.key' => 'base64:'.base64_encode(random_bytes(32))])`) per il middleware web; CSRF auto-bypassato nei test.

## [2026-06-02] #5 — README didattici (requisito di prodotto)
Contesto: indicazione utente. L'ecosistema è complesso/enterprise.
Lezione: ogni README deve essere **prolisso e didattico** per junior/non-esperti di auth: spiegare cosa fa, come funziona (passo-passo + ASCII), come si monta, OGNI opzione di config (tabella), e **molti esempi** (≥4-6 per package). Glossario dei termini (OTP, step-up, AAL, passkey, dynamic linking). Meglio "troppo spiegato" che criptico.
