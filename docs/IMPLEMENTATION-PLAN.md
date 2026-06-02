# Laravel Rebel — Implementation Plan & Engineering Workflow

## Context

L'analisi strategica della suite `padosoft/laravel-rebel-*` è completa (5 doc + `docs/`). Ora si passa all'**implementazione reale**. L'utente ha creato **1 repo GitHub per package** e li ha clonati in `C:\xampp\htdocs\` (12 repo prioritari). Questo piano definisce: (a) il **workflow ingegneristico obbligatorio** (branch/PR/Copilot-review/CI/merge, LESSON/PROGRESS, README wow, tag+release), (b) il **design-lock** dei 32 problemi emersi dall'audit, (c) la **scomposizione in macro-task (package) e sotto-task (feature)** con guardrail (unit test PHP, Vite, Playwright per UI), seguendo l'ordine: **core → email-otp → bridge-fortify → step-up → channels + channel-twilio → admin-api → [STOP prima di admin] → admin → sessions/recovery → ai-guard → extra → meta**.

**Obiettivo di questo round (automode):** implementare fino a **`admin-api` incluso**, fermarsi **prima di `admin`**, chiedere dove si trova il template grafico creato dall'utente, poi proseguire.

**Toolchain verificato in locale:** PHP 8.4.21, Composer 2.9.7, Node 25 / npm 11.6, `gh` autenticato (lopadova, SSH), `copilot.exe` installato (WinGet). **Target: Laravel 12 + 13, PHP 8.3 + 8.4 + 8.5.** Constraint `illuminate/support: ^12.0|^13.0`, `php: ^8.3`. Testbench `^10.0|^11.0` (10=L12, 11=L13), Pest 4, Larastan 3 (PHPStan level max), Pint, `spatie/laravel-package-tools`.

**Repo presenti** in `C:\xampp\htdocs\` (tutti con nome `laravel-rebel-*`, allineati al composer name `padosoft/laravel-rebel-*`): `laravel-rebel-core`, `-email-otp`, `-bridge-fortify`, `-step-up`, `-channels`, `-channel-twilio`, `-admin-api`, `-admin`, `-sessions`, `-recovery`, `-ai-guard`, `-auth` (meta). Tutti su `main`, con `LICENSE`+`README.md`, remote SSH. *(Il repo Twilio è stato rinominato in `laravel-rebel-channel-twilio` e riclonato — naming ora coerente.)*

---

## A. Workflow ingegneristico OBBLIGATORIO (per ogni repo)

> Queste regole vanno scritte in `AGENTS.md`/`CLAUDE.md` di ogni repo e in una skill (vedi Task T0). Sono la Definition of Done.

### A1. Branching & PR (per-repo) — UNA PR per macro-task
```
main
 └─ feat/<macro>   (UN branch per macro-task = package, off main)
```
- I **sotto-task** sono lavorati come **commit locali** sul branch macro (loop LOCALE A2.a). **Niente PR per sotto-task.**
- A **macro-task completo** (tutti i sotto-task chiusi in locale): push del branch → **UNA sola PR `feat/<macro>` → main** con gate GitHub completo (A2.b) → merge → tag/release.
- Commit: gitmoji + messaggio chiaro; `Co-Authored-By` come da regole harness.

### A2. Definition of Done — due livelli

#### A2.a — Loop LOCALE per OGNI sotto-task (niente PR)
```
1. Implementa + guardrail:
   - Pest per TUTTA la logica
   - se UI/UX (Blade/JS pubblicabili) -> Vite build + Playwright di TUTTE le interazioni
   - (solo codice -> niente Playwright)
2. Verde in locale: composer test ; composer phpstan (max) ; composer pint --test ;
   se UI: npm run build + npx playwright test
3. Review Copilot LOCALE:
   - git diff origin/main...HEAD  (TUTTO il diff del branch; se grande -> salva su file temp)
   - copilot --yolo -p "/review <diff|@file>: bug/sicurezza/stile/guardrail mancanti"
     (MAI `copilot` senza `-p` = hang. Vedi LESSON.)
   - applica fix finché 0 commenti rilevanti
4. Commit locale sul branch macro. Aggiorna PROGRESS.md (+ LESSON.md se appreso qualcosa).
   -> passa al sotto-task successivo
```

#### A2.b — Gate GitHub UNA volta, a macro-task completo (PR macro→main)
```
1. git push del branch macro
2. gh pr create  (feat/<macro> -> main)
3. gh pr edit <n> --add-reviewer @copilot   (+ verifica review partita:
     gh pr view <n> --json reviewRequests,reviews)
4. Attendi: CI tutti verdi  E  commenti Copilot completati
5. Verde + 0 commenti aperti -> gh pr merge --squash  -> macro DONE
   Altrimenti -> fixa (test rotti + commenti Copilot) in locale (loop A2.a) -> push ->
                 RICHIAMA nuova review Copilot -> ripeti finché verde
6. Aggiorna LESSON.md con gli insight Copilot. Poi tag vX.Y.Z + gh release create (A6)
```

### A3. File di stato (canonici, nel repo meta `laravel-rebel-auth/docs/`, committati)
- **`PROGRESS.md`**: cosa sto facendo ORA (repo, branch, sotto-task, stato loop) → per ripartire dopo interruzioni.
- **`LESSON.md`**: scoperte/errori/fix/insight (specie da review Copilot). **Va passato nel contesto a ogni subagent parallelo e a me stesso a ogni nuova sessione.** Append-only con data.
- All'avvio di ogni sessione/subtask: **leggi prima `LESSON.md` e `PROGRESS.md`**.

### A4. Per-package skeleton standard (Task iniziale di ogni macro)
```
composer.json (name, description, PSR-4 Padosoft\Rebel\..., extra.laravel.providers, scripts)
src/<Pkg>ServiceProvider.php (spatie/laravel-package-tools)
config/rebel-*.php
database/migrations/* (se applicabile)
tests/ (Pest + TestCase + Testbench)  + tests/e2e/ Playwright (se UI)
.github/workflows/ci.yml (matrix php 8.3/8.4/8.5 x laravel 12/13; jobs: pest, pint, phpstan [, playwright se UI])
pint.json, phpstan.neon.dist, phpunit.xml.dist
resources/screenshoots/Laravel-Rebel-banner.png  (copiato fisicamente dal banner condiviso)
AGENTS.md + CLAUDE.md (regole workflow A1-A2)  +  docs/ (ADR/flows specifici)
CHANGELOG.md, .gitignore, .gitattributes
```
Banner sorgente: `C:\Users\lopad\Downloads\laravel-rebel\Laravel-Rebel-banner.png` → copia in `resources/screenshoots/` di ogni repo.

### A5. README "wow" — STEP FINALE OBBLIGATORIO di ogni macro-task
> **Ogni package**, come ultimo sotto-task prima della PR macro→main, deve avere il README "wow" completo. Senza, il macro-task NON è concluso (gate A2.b).

Struttura (stile AskMyDocs): Titolo+tagline · banner (`resources/screenshoots/...`) · **badges** (Laravel 12/13, PHP 8.3+, CI, coverage, PHPStan max, Packagist, downloads, License MIT, release) · **TOC** · "What it is" (what/why/for whom) · "Why — i moat" (tabella ★) · feature tables per area · **card-battle** vs Shopify/community pertinente · **Quick start (5 min) a prova di junior** (prereq → require → publish → .env → esempio che gira) · esempi (web + mobile/Sanctum) · Architecture (ASCII) · screenshots (se in `resources/`) · docs · license/changelog. Tono: autorevole, onesto, proof-driven (test count, ADR ref). Skeleton completo in `docs/README-standard.md` (già creato).

> **REQUISITO DIDATTICO (obbligatorio in OGNI README).** L'ecosistema è enterprise e complesso: i README devono essere **prolissi e documentali**, scritti perché un **junior o un non-esperto di auth/sicurezza** capisca **subito**:
> - **cosa fa** il package (in parole semplici, con un glossario dei termini: OTP, step-up, AAL, passkey, dynamic linking, ecc.);
> - **come funziona** (flusso passo-passo, anche con diagrammi ASCII e "cosa succede quando…");
> - **come si monta** (install passo-passo a prova di junior, con ogni comando e ogni `.env`);
> - **quali opzioni/config** esistono (tabella di OGNI chiave di config: nome, default, cosa fa, quando cambiarla);
> - **MOLTI esempi** d'uso reali e copia-incolla (più scenari: web, mobile/Sanctum, casi d'errore, edge case, "ricette" comuni). Almeno 4-6 esempi per package, di più per i package centrali.
>
> Meglio "troppo spiegato" che criptico: l'accessibilità è un requisito di prodotto, non un extra. Questo vale anche per i commenti/PHPDoc nel codice degli esempi.

#### A5.bis — README "ecosistema" (SOLO `core` e meta `auth`)
I README di **`laravel-rebel-core`** e del **meta `laravel-rebel-auth`** devono, oltre allo standard, **spiegare per intero l'ecosistema complesso** così che un lettore capisca TUTTO:
```
- visione d'insieme: cos'è Rebel (control plane su Fortify) e a cosa serve
- mappa di TUTTI i package: per ciascuno nome + a cosa serve + cosa NON fa (1-2 righe)
- dependency DAG (diagramma ASCII): chi dipende da chi, ordine d'installazione
- funzionalità totale end-to-end: login passkey-first/email-OTP (web + mobile Sanctum),
  step-up purpose/risk-based + SCA dynamic linking, channels/anti-fraud, recovery,
  sessions/devices, admin, ai-guard, multi-tenant, compliance NIST/PSD2/GDPR
- 2-3 flussi narrati end-to-end (sequence ASCII): es. customer passwordless login,
  checkout-credit-order con step-up+dynamic-linking, account recovery
- come i pezzi si compongono (core = linguaggio comune; bridge = Fortify; ecc.)
- link ai README dei singoli package
```
Il README del **meta** è la versione "flagship/wow" con **mega card-battle** (vedi `docs/positioning.md`); quello del **core** è la "porta d'ingresso tecnica" che spiega contratti/value-object condivisi MA con la stessa visione d'insieme dell'ecosistema.

### A6. Release (a macro→main mergeato)
`git tag vX.Y.Z` (semver; primo rilascio `v0.1.0`) → `git push --tags` → `gh release create vX.Y.Z` con note. Registrazione Packagist a carico utente (auto-update via webhook dopo prima registrazione).

---

## B. Design-lock (risoluzione dei 32 problemi d'audit) — ADR-0005

Da scrivere come `docs/adr/ADR-0005-design-lock.md` nel repo `core` (i contratti vivono lì) e referenziato dagli altri. Decisioni:

**ID & storage**
- **ULID** per tabelle ad alto volume/temporali: `rebel_email_otp_challenges`, `rebel_step_up_challenges`, `rebel_auth_events`, `rebel_metric_buckets`. **UUID** per `rebel_devices`, `rebel_sessions`, recovery codes. *(audit #17)*
- `rebel_email_otp_challenges` aggiunge **`code_salt`** (string 64, server-only) — mancava nel migration. *(#1)*
- Migrazioni **auto-discovered** (`->hasMigration()` / loadMigrationsFrom); test up/down in CI per ogni package. *(#16)*

**OTP / verifica**
- Verifica atomica: **Redis Lua quando Redis disponibile** (check+consume+attempts atomico), **fallback DB `lockForUpdate()` in transaction**. Store selezionabile via config `rebel.store=redis|database`. *(#2, #20)*
- **Timing anti-enumeration**: target fisso (default **250ms**) + jitter ±50ms su `start`; misura wall-clock; **non** attendere la queue dell'email; payload JSON identico per tutti i rami (account esiste o no); risposta **paddata a dimensione minima fissa**. Iniettare un **Clock PSR-20** + `Carbon::setTestNow` per testabilità. *(#7, #21, #28)*
- **Idempotency-key**: header client opzionale `Idempotency-Key`, altrimenti derivata `HMAC(subject?|identifier|purpose|window)`; store Redis TTL = challenge_ttl + 1h; start duplicato ritorna stesso `challenge_id` senza reinvio. *(#8)*
- **Pepper/key rotation**: config `rebel.peppers = [1 => secret, 2 => secret]` + `rebel.pepper_current = 2`; verifica prova current poi versioni deprecate entro grace; `key_version` salvato su ogni riga HMAC. Comando rotazione documentato. *(#6)*

**Login result / token / step-up**
- **`LoginResult`** = `final readonly class` con `isWeb()/isMobile()`, `sessionData(): ?array`, `tokenPair(): ?TokenPair`. `TokenIssuer` contract wrappa l'estensione Sanctum (access+refresh). **Token porta claim `tenant_id`**; middleware valida tenant del token == contesto. *(#3, #29)*
- **Step-up token-native**: `device_id` derivato dal token (Sanctum `accessToken->id`) con fallback `hash(ip|user_agent)`; conferma keyed `subject+purpose+device_id+binding_hash`; `fortify_password_confirm` resta **web-only**. *(#4)*
- **`binding_hash`** = `hash_hmac('sha256', canonical_json([amount,currency,payee,orderRef]), pepper[v])`; calcolato e **congelato** su `RebelStepUp::require()` per il TTL; se importo/payee cambiano → middleware 423 e nuova `require()`. Confronto `hash_equals`. *(#5, #30)*

**Assurance / config**
- Comando **`php artisan rebel:validate-config`**: valida combinazioni purpose/driver/assurance, fallisce se un purpose ad alta assurance ammette solo driver sotto soglia; **gira in CI**. *(#14)*
- **Multi-guard**: `config('rebel.guards')` con sezione per guard (`customers`, `admins`…); middleware inferisce guard da `auth()->guard()`. *(#15)*
- Audit logga **`assurance_downgrade_reason`** quando si usa un driver non preferito (fallback). *(#26)*

**Tenant / errori / log**
- `tenant_id` nullable **solo** per tabelle di sistema condivise; tutto il resto scoped via **global scope `BelongsToTenant`** + assert in admin-api. *(#24)*
- **Forma errore JSON normalizzata**: `{ "error": <code>, "message": <generic>, "details"?: {} }` con status/È messaggio identici a prescindere dal motivo (no info leak); web → 423/redirect, JSON → 423/403 strutturato. *(#23)*
- **Redaction log**: lista campi redatti (otp, code, secret, bearer, password, pepper) testata con fake logger in ogni package. *(#27)*

**Feature mancanti → task dedicati**
- **Passkey-first login**: orchestrazione in `bridge-fortify` (M-bridge): route `GET /login/passkey/options`, `POST /login/passkey`, fallback `email_otp`. *(#9)*
- **WhatsApp HSM template per locale** + fallback SMS in `channel-twilio`. *(#10)*
- **Webhook delivery receipts** (Twilio status callback) → aggiorna stato challenge in `channels`. *(#11)*
- **OpenAPI 3.1** per admin-api (generato, validato in CI). *(#12)*
- **Health endpoint** `GET /admin/rebel/api/v1/health` (status, queue_lag, provider_status, last_event_at). *(#13)*
- **Testing fakes**: `FakeTwilioProvider`, `FakeTokenIssuer`, `FakeAiClient`, `FakeClock` registrati nei TestCase. *(#19)*
- **Queue**: notifiche su connessione `rebel` (queue dedicata), timeout 30s, retry 3, backoff; verify NON attende invio. *(#18)*
- **Recovery codes**: 10 codici, `HMAC(code|salt|key_version)`, single-use, generati all'enrollment, mostrati una volta (download). *(#22)*
- **Batch admin ops** (es. bulk logout-everywhere) + **feature-flag sezioni admin** (AI solo se ai-guard installato). *(#31, #32)*

---

## C. Scomposizione in macro-task (package) e sotto-task

> Legenda guardrail: **U**=Pest unit/feature, **S**=PHPStan max, **P**=Pint, **E**=Playwright E2E (solo UI), **CR**=Copilot review locale. Ogni sotto-task = **commit locale** sul branch macro con **loop LOCALE A2.a** (U/S/P[/E] + CR). A fine package: **UNA PR macro→main** con gate **A2.b** (CI + `@copilot` + merge) → tag/release.

### T0 — Governance bootstrap (nel repo `laravel-rebel-auth` meta) — branch `chore/governance`
- T0.1 `docs/IMPLEMENTATION-PLAN.md` (copia di questo piano) + `docs/LESSON.md` (seed: #1 `copilot` solo con `-p` o si blocca; #2 banner sorgente in `Downloads\laravel-rebel\Laravel-Rebel-banner.png`→`resources/screenshoots/`; #3 verificare flag `copilot` e disponibilità `@copilot` reviewer su gh) + `docs/PROGRESS.md` (tabella stato per repo).
- T0.2 `AGENTS.md` + `CLAUDE.md` template (regole A1–A6) + **skill** `rebel-build-workflow` (in `.claude/skills/`) che incapsula la DoD/loop.
- T0.3 Script `sync-banner` (copia banner in `resources/screenshoots/` dei repo) + script helper review Copilot (`scripts/cr.ps1`) e PR (`scripts/pr.ps1`).
- Guardrail: nessun codice (docs/tooling) → U/E n.a.; verifica: i file esistono, lo script copia il banner. PR `chore/governance → main`, loop A2 (CR sì, CI banale).

### T1 — `laravel-rebel-core` — branch `feat/core`  → release `v0.1.0`
- T1.0 skeleton (A4) + ADR-0005 (design-lock) + ADR-0001..0004 copiati in `docs/adr/`.
- T1.1 Value objects: `EmailIdentifier`/`PhoneIdentifier`/`GenericIdentifier` (`AuthIdentifier`), normalizzazione, `masked()`, `hmac()` keyed+`key_version`. **U,S,P**
- T1.2 `Aal` enum, `AssuranceLevel` (aal/phishing_resistant/amr/restricted), `TransactionContext` + canonical serialize, `binding_hash` helper. **U,S,P**
- T1.3 `SecurityContext::fromRequest` + `TenantContext`/`DeviceContext`, ip/ua HMAC, request_id. **U,S,P**
- T1.4 `RiskAssessment`/`RiskLevel`/`RecommendedAction`; bounds 0–100, reasons machine-readable. **U,S,P**
- T1.5 Contratti: `SubjectResolver`,`TenantResolver`,`RiskEvaluator`,`AuditLogger`,`TokenIssuer`,`SessionRegistry`,`DeviceTrust`,`BotProtection`,`RateLimiter`,`KeyedHasher`,`Clock`(PSR-20). **U,S,P**
- T1.6 `LoginResult`+`TokenPair`; `AuditEvent` + `AuthEvent` types enum; `DatabaseAuditLogger` + `rebel_auth_events` migration (ULID, key_version, aal/amr, prev_hash opz.). **U,S,P**
- T1.7 `KeyedHasher` (pepper registry + rotation), `FakeClock`, fakes base; redaction helper + test fake-logger. **U,S,P**
- T1.8 `rebel:validate-config` command (scheletro, esteso da step-up) + `BelongsToTenant` global scope trait. **U,S,P**
- T1.9 **README "ecosistema" (A5.bis)**: oltre allo standard wow, spiega l'INTERO ecosistema (mappa di tutti i package, dependency DAG, funzionalità totale, flussi end-to-end) come porta d'ingresso tecnica + CHANGELOG; gate: PHPStan max, 100% sui value object critici, nessuna dip Fortify/Twilio/AI.
- → PR `feat/core → main`, merge, **tag v0.1.0 + release**.

### T2 — `laravel-rebel-email-otp` — branch `feat/email-otp` (UI: Blade login/verify) → `v0.1.0`
- T2.0 skeleton + dipendenza `padosoft/laravel-rebel-core`.
- T2.1 Migration `rebel_email_otp_challenges` (ULID, `code_hmac`,`code_salt`,`key_version`,`idempotency_key`, indici composti). **U,S,P**
- T2.2 `NumericOtpGenerator` (CSPRNG, 6/8 cifre per purpose) + hasher (salt+pepper+key_version). **U,S,P**
- T2.3 `StartEmailOtpChallenge` (normalizza, risk, rate-limit, invalida pendenti, genera, queue mail, audit, **timing-pad + idempotency**, anti-enum). **U,S,P**
- T2.4 `VerifyEmailOtpChallenge` atomico (Redis Lua / DB lock), single-use/replay, attempts, **emette `LoginResult`** (session|token via `TokenIssuer`). **U,S,P**
- T2.5 `ResendEmailOtpChallenge` (invalida precedente, cooldown). **U,S,P**
- T2.6 Notification email + template per-locale; prune command. **U,S,P**
- T2.7 Route JSON opzionali + Blade views (`login`,`verify`) vanilla JS (paste OTP, countdown). **U,S,P,E** (Playwright: happy path, codice errato, scaduto, resend, anti-enum UI, paste, a11y).
- T2.8 README wow + card-battle vs Spatie OTP / Shopify; CHANGELOG. → PR→main, tag **v0.1.0**.

### T3 — `laravel-rebel-bridge-fortify` — branch `feat/bridge-fortify` → `v0.1.0`
- T3.0 skeleton; feature-detect `class_exists(Fortify)`; fixture testbench con Fortify.
- T3.1 Service provider: registra driver solo se Fortify presente; diagnostica chiara se assente. **U,S,P**
- T3.2 Driver `fortify_password_confirm` (web-only, session) → assurance aal2/medium. **U,S,P**
- T3.3 Driver `fortify_passkey_confirm` (phishing_resistant) + disponibilità per-utente. **U,S,P**
- T3.4 Driver `fortify_totp` (+ recovery code single-use, audit). **U,S,P**
- T3.5 Event mapper Fortify→Rebel audit (Login/Failed/Lockout/2FA*/Passkey*). **U,S,P**
- T3.6 **Passkey-first login orchestration** (route options/login + fallback email_otp). **U,S,P** *(audit #9)*
- T3.7 README wow + card-battle vs Fortify-nativo; tag **v0.1.0**.

### T4 — `laravel-rebel-step-up` — branch `feat/step-up` (UI: challenge view) → `v0.1.0`
- T4.0 skeleton + dip core; estende `rebel:validate-config`.
- T4.1 Migration `rebel_step_up_challenges` (assurance, binding_hash/bound_*, device_id, key_version). **U,S,P**
- T4.2 Config purpose policies (required_assurance, require_phishing_resistant, drivers, ttl, sca/exemptions) + validazione fail-fast. **U,S,P**
- T4.3 Driver registry + resolver (rifiuta driver sotto soglia; ordine/fallback; downgrade flag). **U,S,P**
- T4.4 Middleware `rebel.stepup:{purpose}` (web+JSON 423, redirect intended, audit). **U,S,P**
- T4.5 Driver `email_otp` per step-up (purpose-scoped, distinto da login). **U,S,P**
- T4.6 **SCA dynamic linking**: `TransactionContext`, binding freeze/recompute, UI mostra importo+payee. **U,S,P,E** (Playwright: challenge, importo cambia→re-auth, fallback driver).
- T4.7 Risk evaluator hook (signals new_device/high_value/b2b_credit/new_country/velocity). **U,S,P**
- T4.8 README wow; tag **v0.1.0**.

### T5 — `laravel-rebel-channels` + `laravel-rebel-channel-twilio` (2 repo separati, 1 PR ciascuno) → `v0.1.0`
- Ordine: prima `channels` (branch `feat/channels` → PR → tag), poi `channel-twilio` (branch `feat/channel-twilio` → PR → tag).
- T5.0 skeleton entrambi; channels dip core; twilio dip channels.
- T5.1 Contratti `VerificationProvider`/`MessageDeliveryChannel`/`VerificationRouter`/`DeliveryResult` + fakes. **U,S,P**
- T5.2 Rate-limit matrix multidimensionale (Redis) + `BotProtection` gate. **U,S,P** *(#20)*
- T5.3 Fallback router + cooldown condiviso + audit. **U,S,P**
- T5.4 (twilio) `TwilioVerifyProvider` SMS/WhatsApp/Voice (HTTP fake, error mapping, no-secret-log). **U,S,P**
- T5.5 (twilio) **Webhook delivery receipts** + aggiorna stato challenge. **U,S,P** *(#11)*
- T5.6 Anti toll-fraud/IRSF: geo allowlist, per-prefix cap, conversion monitor + auto-trip, Fraud Guard. **U,S,P** *(#10 WhatsApp HSM locale)*
- T5.7 README wow (entrambi); tag **v0.1.0** (entrambi).

### T6 — `laravel-rebel-admin-api` — branch `feat/admin-api` → `v0.1.0`
- T6.0 skeleton + dip core; module/permission registry (spostato qui dal core).
- T6.1 Auth middleware configurabile + permission registry + tenant scoping/assert. **U,S,P**
- T6.2 **Metrics projector** (eventi→`rebel_metric_buckets`, job orario) — vive qui, non in ai-guard. **U,S,P** *(#25)*
- T6.3 Endpoint: security/overview, otp/funnel, step-up/funnel, channels/performance, providers/health (read-model, cursor). **U,S,P**
- T6.4 auth-events explorer (filtri indicizzati, cursor, export queued+audit) + subjects devices/sessions. **U,S,P**
- T6.5 risk-rules (list + **simulate**), anomalies (list/detail/actions con human-review), **health endpoint**, **batch ops**. **U,S,P** *(#13,#32)*
- T6.6 **OpenAPI 3.1** generato + validato in CI. **U,S,P** *(#12)*
- T6.7 README wow; tag **v0.1.0**.

### ⏸️ STOP — prima di `admin`
Dopo merge di `admin-api`: **chiedere all'utente dove ha salvato il template grafico** dell'admin (path), aggiornare `PROGRESS.md`, poi riprendere con T7.

### T7 — `laravel-rebel-admin` (UI completa) — branch `feat/admin` *(dopo template)* → `v0.1.0`
Monta il template utente sopra l'admin-api; Blade+AJAX+vanilla JS; 10 sezioni (spec `admin-panel-template-spec.md`). Guardrail **U,S,P,E**: Playwright per **tutte** le interazioni di ogni sezione (loading/empty/error, filtri, azioni con conferma, tenant/period switch, a11y). Vite build assets pubblicabili. README wow + screenshots.

### T8 — `sessions` + `recovery` — branch `feat/sessions-recovery` → `v0.1.0`
Device/session registry, logout-everywhere, refresh rotation+reuse-detection; recovery=step-up alta assurance, recovery codes. **U,S,P** (no UI propria → no E).

### T9 — `ai-guard` — branch `feat/ai-guard` → `v0.1.0`
Feature extraction/anomaly cases (deterministico) + AI explain/suggest (prompt sanitizzato, no PII/OTP, human review). Legge i bucket (non aggrega). **U,S,P**.

### T10 — extra bridges/providers (`bridge-passkeys`, `-spatie-otp`, `-laragear-2fa`, `-otpz`, `channel-vonage/bird/telegram/discord`, `bot-protection`)
Da creare repo on-demand quando si arriva qui (fuori dal set prioritario attuale). **U,S,P**.

### T11 — `laravel-rebel-auth` (meta) — branch `feat/meta` → `v0.1.0`
`composer.json` con require dei package + `suggest`; install command; **README "wow" flagship + ecosistema (A5.bis)**: mega card-battle (`docs/positioning.md`), mappa di TUTTI i package con ruolo, **dependency DAG**, funzionalità totale end-to-end, 2-3 flussi narrati (login passwordless, checkout-credit-order con SCA, recovery), quickstart bundle, esempi web+mobile, link a tutti i README. Tag **v0.1.0**.

### T12 — Harvest finale (task conclusivo del piano)
Rileggi `LESSON.md` e potenzia **rules/skills/`AGENTS.md`** di tutti i repo con il know-how accumulato; aggiorna la skill `rebel-build-workflow`; commit dedicato.

---

## D. File critici per repo (pattern ripetuto)
`composer.json`, `src/<Pkg>ServiceProvider.php`, `config/rebel-*.php`, `database/migrations/*`, `src/**` (Actions/ValueObjects/Contracts/Drivers), `tests/**` (Pest) [+ `tests/e2e/**` Playwright, `vite.config.js`, `package.json` se UI], `.github/workflows/ci.yml`, `pint.json`, `phpstan.neon.dist`, `phpunit.xml.dist`, `resources/screenshoots/Laravel-Rebel-banner.png`, `AGENTS.md`,`CLAUDE.md`,`README.md`,`CHANGELOG.md`,`docs/**`. Rappresentativi: `C:\xampp\htdocs\laravel-rebel-core\...`, `...\laravel-rebel-email-otp\...`.

## E. Verifica end-to-end (per ogni step e a fine package)
1. `composer test` (Pest) verde; **PHPStan max** verde; **Pint --test** verde.
2. Se UI: `npm run build` + `npx playwright test` verdi (testbench skeleton app che renderizza le view/admin).
3. Copilot review locale 0 commenti → push → PR → `--add-reviewer @copilot` partita → **CI verdi** + commenti Copilot risolti → merge.
4. `rebel:validate-config` verde in CI; migrazioni up/down testate.
5. A package concluso: README wow completo, banner presente, `git tag vX.Y.Z` + `gh release create`.
6. `PROGRESS.md`/`LESSON.md` aggiornati ad ogni step.

## F. Rischi & note
- **Copilot CLI**: usare sempre `-p`; verificare flag reali (`--allow-all-tools`/`--yolo`; `--autopilot` da confermare) → annota in LESSON.
- **`gh ... --add-reviewer @copilot`**: richiede Copilot code review abilitato sul repo/org; se non disponibile, il gate primario resta la **review Copilot locale** + CI (annota in LESSON e procedi).
- **Playwright in CI**: serve build asset + skeleton testbench; cache browser.
- **Ordine dipendenze**: core prima di tutto; channels prima di twilio; admin-api prima di admin; sessions/recovery dopo step-up.
- Salvo questo piano anche in `laravel-rebel-auth/docs/IMPLEMENTATION-PLAN.md` (T0.1) dopo approvazione.
