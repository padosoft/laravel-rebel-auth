# PROGRESS.md — stato di avanzamento (Laravel Rebel)

> **Regola:** aggiornare ad OGNI sotto-task. Serve a riprendere esattamente da dove si è interrotto dopo una sessione chiusa bruscamente. Leggere insieme a `LESSON.md` all'avvio.

## Stato corrente
- **Sessione:** 2026-06-02
- **Round automode:** **GOAL = completare TUTTA la roadmap** (T1→T13), senza stop. Per `admin` (T7) costruisco la UI baseline dalla spec `admin-panel-template-spec.md` (l'utente potrà restilizzarla/sostituirla col proprio template in seguito) → niente blocco.
- **Secrets pronti (in `.env` git-ignored, MAI in md/commit):** Twilio in `laravel-rebel-channel-twilio/.env`, Mailtrap in `laravel-rebel-email-otp/.env`. Numero test utente: solo in `.env`. Repo `laravel-rebel-demo` clonato (T13).
- **Macro-task in corso:** **T1 — core** (branch `feat/core`). T0 governance ✅ mergeato (PR #1).
- **T1.0 skeleton ✅ committato** + **toolchain VALIDATO green**: Pest 4 ✓, PHPStan max ✓, Pint ✓ (Laravel 13.13, Testbench 11, Larastan 3, pest-plugin-laravel 4.1).
- **Prossimo:** T1.1 value objects (`AuthIdentifier`/Email/Phone), T1.2 assurance AAL/AMR + TransactionContext, ... T1.9 README ecosistema.
- **Gate review:** utente ha **Copilot Plus** → ritentare review `@copilot` sulla PR di `core` (LESSON #4). Backup: review Copilot LOCALE (`scripts/cr.ps1`).
- **Novità piano:** READMEs didattici + setup provider/`.env.example` su tutti i package; suite test "live" (Twilio/Mailtrap free tier, secrets CI); nuovo package **T13 `laravel-rebel-demo`** (app L13 integrazione, cresce incrementale).

## Cosa sto facendo ORA
**T1 `core` ✅ COMPLETO** (v0.1.0). **Inter-package deps via VCS validate** (email-otp→core).

**T2 `laravel-rebel-email-otp`** (branch `feat/email-otp`) — in corso, 21 test verdi, PHPStan max (512M), Pint:
- ✅ T2.0 skeleton + dep core(VCS) · ✅ T2.1 migration · ✅ T2.2 generator CSPRNG
- ✅ T2.3 Start (anti-enum timing, idempotency, 1-active, delayed subject) · ✅ T2.4 Verify (atomico/single-use/block) · ✅ T2.5 Resend (cooldown/max) · ✅ T2.6 Notification queued + RebelEmailOtp facade
**Prossimo:** T2.7 Blade views (login/verify) + Vite + **Playwright E2E** (prima volta: setup testbench skeleton app) · T2.6b prune command · T2.8 README "wow" (+ Web Admin Panel screenshot) → PR `feat/email-otp→main` (review @copilot via REST) → tag v0.1.0. Mailtrap `.env` per test "live".
Sottotask: T2.1 migration challenge (ULID, code_hmac+code_salt+key_version+idempotency) · T2.2 generator+hasher · T2.3 StartChallenge (anti-enum timing, idempotency, rate-limit, bot gate) · T2.4 VerifyChallenge atomico (LoginResult web|token) · T2.5 Resend · T2.6 notification+prune · T2.7 Blade views + Playwright · T2.8 README + PR + tag.

## Tabella macro-task (questo round)
| # | Package | Repo | Branch | Stato |
|---|---|---|---|---|
| T0 | governance | laravel-rebel-auth | chore/governance | ✅ done (PR #1) |
| T1 | core | laravel-rebel-core | feat/core | ✅ done (v0.1.0) |
| T2 | email-otp | laravel-rebel-email-otp | feat/email-otp | ⬜ |
| T3 | bridge-fortify | laravel-rebel-bridge-fortify | feat/bridge-fortify | ⬜ |
| T4 | step-up | laravel-rebel-step-up | feat/step-up | ⬜ |
| T5a | channels | laravel-rebel-channels | feat/channels | ⬜ |
| T5b | channel-twilio | laravel-rebel-channel-twilio | feat/channel-twilio | ⬜ |
| T6 | admin-api | laravel-rebel-admin-api | feat/admin-api | ⬜ |
| ⏸️ | STOP prima di admin → chiedere path template | | | |

## Note di ripresa
- Piano completo: `docs/IMPLEMENTATION-PLAN.md` (questo repo) / `C:\Users\lopad\.claude\plans\synchronous-dazzling-lynx.md`.
- Workflow/DoD: `AGENTS.md`. Lezioni: `docs/LESSON.md`.
- Spec admin panel (per T7): `C:\xampp\htdocs\laravel-rebel-admin\docs\admin-panel-template-spec.md` (non committato).
