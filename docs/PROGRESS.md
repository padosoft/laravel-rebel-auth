# PROGRESS.md — stato di avanzamento (Laravel Rebel)

> **Regola:** aggiornare ad OGNI sotto-task. Serve a riprendere esattamente da dove si è interrotto dopo una sessione chiusa bruscamente. Leggere insieme a `LESSON.md` all'avvio.

## Stato corrente
- **Sessione:** 2026-06-03
- **Round automode:** **GOAL = vai al 100% di T13**, senza stop. Per `admin` (T7) costruisco la UI dal template utente `Laravel Rebel Admin.html` in `C:\Users\lopad\Downloads\laravel-rebel\laravel-rebel-web-panel`.
- **Secrets pronti (in `.env` git-ignored, MAI in md/commit):** Twilio in `laravel-rebel-channel-twilio/.env`, Mailtrap in `laravel-rebel-email-otp/.env`. Numero test utente: solo in `.env`. Repo `laravel-rebel-demo` clonato (T13).
- **Macro-task in corso:** **T4 — step-up** (branch `feat/step-up`) → **PR #1 APERTA**, in attesa CI + review bot (@copilot richiesto via REST). T0/T1/T2 ✅ mergeati.
- **Ordine T3/T4 invertito:** `step-up` (T4) costruito PRIMA di `bridge-fortify` (T3) perché il bridge dipende dal contratto `StepUpDriver` definito qui.
- **Gate review:** `@copilot` reviewer SI usa via REST (`gh api ... /requested_reviewers -f "reviewers[]=copilot-pull-request-reviewer[bot]"`); LESSON #4 superato. Backup: review Copilot LOCALE (`scripts/cr.ps1`).

## Cosa sto facendo ORA
**T1 `core` ✅ v0.1.0** · **T2 `email-otp` ✅ v0.1.0** · **T4 `step-up` → PR #1 aperta** (15 test Pest verdi, PHPStan max, Pint; 8 fix da 2 round review Copilot locale: device binding simmetrico, assurance vs policy corrente, canonical JSON anti-injection, start() atomico, Aal::tryFrom fail-closed, subjectId fail-fast, TransactionContext validation; README didattico + .env.example + CHANGELOG; LICENSE→MIT).

**Attesa gate A2.b su PR #1 step-up:** CI (matrix 8.3/8.4/8.5 × L12/13) + review bot. Poi merge squash → tag **v0.1.0** → release.

**Prossimo dopo merge step-up: T3 `laravel-rebel-bridge-fortify`** (branch `feat/bridge-fortify`). Solo codice (no UI). Driver Fortify (password-confirm web-only, passkey, totp) + event mapper + passkey-first login + driver step-up `fortify_passkey_confirm`/`fortify_totp` (implementano `StepUpDriver` di step-up). Feature-detect `class_exists(Fortify)`. Dipende da core+step-up (VCS).

## Tabella macro-task (questo round)
| # | Package | Repo | Branch | Stato |
|---|---|---|---|---|
| T0 | governance | laravel-rebel-auth | chore/governance | ✅ done (PR #1) |
| T1 | core | laravel-rebel-core | feat/core | ✅ done (v0.1.0) |
| T2 | email-otp | laravel-rebel-email-otp | feat/email-otp | ✅ done (v0.1.0) |
| T4 | step-up | laravel-rebel-step-up | feat/step-up | 🔄 PR #1 (gate) |
| T3 | bridge-fortify | laravel-rebel-bridge-fortify | feat/bridge-fortify | ⬜ (dopo step-up) |
| T5a | channels | laravel-rebel-channels | feat/channels | ⬜ |
| T5b | channel-twilio | laravel-rebel-channel-twilio | feat/channel-twilio | ⬜ |
| T6 | admin-api | laravel-rebel-admin-api | feat/admin-api | ⬜ |
| ⏸️ | STOP prima di admin → chiedere path template | | | |

## Note di ripresa
- Piano completo: `docs/IMPLEMENTATION-PLAN.md` (questo repo) / `C:\Users\lopad\.claude\plans\synchronous-dazzling-lynx.md`.
- Workflow/DoD: `AGENTS.md`. Lezioni: `docs/LESSON.md`.
- Spec admin panel (per T7): `C:\xampp\htdocs\laravel-rebel-admin\docs\admin-panel-template-spec.md` (non committato).
